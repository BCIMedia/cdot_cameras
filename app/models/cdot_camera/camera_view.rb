module CdotCamera
  class CameraView < ActiveRecord::Base
    self.table_name = "cdot_camera_camera_views"
    has_attached_file :s3_image
    validates_attachment_content_type :s3_image, content_type: /\Aimage\/.*\z/

    belongs_to :camera
    def update_s3
      path = "http://i.cotrip.org/" + image_location
      begin
        update(s3_image: open(path, {read_timeout: 3}))
      rescue
        cdot_logger = Logger.new(Rails.root.join("log", "#{Rails.env}_cdot.log"), 10, 30 * 1024 * 1024)
        cdot_logger.info("Camera: #{camera_id} - View: #{id} - #{path} - #{$!.message}")
      end
    end

    def s3_image_fetch_url
      if (!s3_image.exists? || Time.now.to_i - s3_image_updated_at.to_i > CdotCamera.configuration.image_cache_time)
        update_s3
      end
      s3_image.url
    end

    def cdot_image_path
      "http://i.cotrip.org/" + image_location
    end
  end

end
