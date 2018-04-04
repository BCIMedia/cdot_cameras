require 'open-uri'
require 'pathname'

module CdotCamera
  class XmlImporter
    attr_reader :libraries

    def initialize
    end

    def cdot_xml
      binding.pry
      conn = Faraday.new(url: CdotCamera.configuration.xml_url)
      conn.basic_auth(CdotCamera.configuration.xml_user, CdotCamera.configuration.xml_pass)
      conn.get

    end

    def xml_cameras
      cdot_xml.xpath("//camera:Camera")
    end

    def import
      xml_cameras.each do |xml_cam|
        cdot_id  = normalize(xml_cam.xpath("camera:CameraId").inner_text)
        camera = Camera.find_or_create_by(id: cdot_id)
        cam_name = normalize(xml_cam.xpath("camera:Name").inner_text)

        binding.pry
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
  end
end
