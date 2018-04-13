require 'open-uri'
require 'pathname'

# CdotCamera::XmlImporter.new.import
module CdotCamera
  class XmlImporter
    attr_reader :libraries

    def initialize
    end

    def cdot_xml
      conn = Faraday.new(url: CdotCamera.configuration.xml_url)
      conn.basic_auth(CdotCamera.configuration.xml_user, CdotCamera.configuration.xml_pass)
      conn.get
    end

    def xml_cameras
      Nokogiri::XML(cdot_xml.body).xpath("//camera:Camera")
    end

    def import
      xml_cameras.each do |xml_cam|
        name     = xml_cam.xpath("camera:Name").text
        cam_lat  = xml_cam.xpath("camera:Location").xpath("global:Latitude").text.to_f
        cam_long = xml_cam.xpath("camera:Location").xpath("global:Longitude").text.to_f
        puts name
        if distance([cam_lat, cam_long], [CdotCamera.configuration.home_lat, CdotCamera.configuration.home_long])
          cdot_id  = xml_cam.xpath("camera:CameraId").text.to_i
          camera = CdotCamera::Camera.find_or_create_by(cdot_camera_id: cdot_id)
          camera.update(name:            xml_cam.xpath("camera:Name").text,
                        description:     xml_cam.xpath("camera:Description").text,
                        latitude:        cam_lat,
                        longitude:       cam_long,
                        source:          xml_cam.xpath("camera:Source").text,
                        icon:            xml_cam.xpath("camera:Icon").text,
                        status:          xml_cam.xpath("camera:Enabled").text == "enabled" ? true : false,
                        weather_station: xml_cam.xpath("camera:IsWeatherStation").text == "false" ? false : true,
                       )
          binding.pry
          xml_cam.xpath("camera:CameraView").each do |camera_view|
            cdot_view_id = camera_view.xpath("camera:CameraViewId").text
            cameraView = CdotCamera::CameraView.find_or_create_by(cdot_view_id: cdot_view_id, cdot_camera_id: cdot_id)
            cameraView.update(name:            camera_view.xpath("camera:CameraName").text,
                              description:     camera_view.xpath("camera:ViewDescription").text,
                              source:          camera_view.xpath("camera:ImageSource").text,
                              direction:       camera_view.xpath("camera:Direction").text,
                              image_location:  camera_view.xpath("camera:ImageLocation").text,
                              display_order:   camera_view.xpath("camera:DisplayOrder").text,
                              road_name:       camera_view.xpath("camera:RoadName").text,
                              road_id:         camera_view.xpath("camera:RoadId").text,
                              mile_marker:     camera_view.xpath("camera:MileMarker").text,
                              last_updated_at: camera_view.xpath("camera:LastUpdatedDate").text)
          end
          binding.pry
        else
          # Camera too far!
        end

        # check_if_name_includes_lib_title(cam_name, xml_cam)
      end
      # process_images
    end

    def process_images
      CloudscoutImageQueue.process(true)
    end

    def check_if_name_includes_lib_title(cam_name, xml_cam)
      libraries.each do |lib|
        if cam_name.include?(normalize(lib.title))
          puts "CDot Cam = #{cam_name}, cams=#{cam_size(xml_cam)}"

          xml_cam.xpath("camera:CameraView").each do |cam_view|
            cam_view_update = cam_view.xpath("camera:LastUpdatedDate").inner_text
            cam_size = cam_size(xml_cam) - 1 if !cam_view_update.blank?
          end
          cam_size(xml_cam) == 0 ? "Cam down or unavailable, not importing" : createAssets(xml_cam, lib)
        end
      end
    end

    def cam_size(cam)
      cam.xpath("camera:CameraView").size
    end

    def createAssets(xml_cam, lib)
      xml_cam.xpath("camera:CameraView").each do |cam_view|
        asset = lib.assets.create(
          site_id: Site.find_by(key: "thecloudscout").id,
          title: cam_view.xpath("camera:ViewDescription").inner_text,
          asset_type_id: AssetType.find_by(handler_name: "MultiImageSlideshowCamera").id,
          source_image_url: "#{Rails.configuration.cdot.base_url}/#{cam_view.xpath("camera:ImageLocation").inner_text}"
        )
        meta_tag = MetaTag.find_or_initialize_by(value: "#{Rails.configuration.cdot.base_url}/#{cam_view.xpath("camera:ImageLocation").inner_text}")
        meta_tag.update(name: "image-url", metable_id: asset.id, metable_type: "Asset")

        # lib.update(assets: [asset])

        puts "Asset created for #{cam_view.xpath("camera:ViewDescription").inner_text}"
      end
    end

    def update
      assets_for_update.each {|asset| asset.source_image_url = asset.meta_tags.first.value; asset.save}

      process_images
    end

    def assets_for_update
      Asset.includes(:site).where(sites: {key: 'thecloudscout'})
    end

    def normalize(text)
      text.to_s.strip.gsub(/[^A-Za-z0-9-\s]+/, "").gsub(/[_\s]+/, '-').downcase
    end

    def distance loc1, loc2
      rad_per_deg = Math::PI/180  # PI / 180
      rkm = 6371                  # Earth radius in kilometers
      rm = rkm * 1000             # Radius in meters

      dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
      dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

      lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
      lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

      a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
      c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

      d = rm * c # Delta in meters
      puts "distance: #{d}"
      d <= CdotCamera.configuration.max_distance
    end
  end
end
