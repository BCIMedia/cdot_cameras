module CdotCamera
  class CameraView < ActiveRecord::Base
    self.table_name = "cdot_camera_camera_views"
    has_attached_file :s3_image
    validates_attachment_content_type :s3_image, content_type: /\Aimage\/.*\z/

    belongs_to :camera
    def update_s3
      update(s3_image: open("http://i.cotrip.org/"+image_location))
    end

    def s3_image_fetch_url
      if (!s3_image.exists? || Time.now.to_i - s3_image_updated_at.to_i > CdotCamera.configuration.image_cache_time)
        update_s3
      end
      s3_image.url
    end
  end

end
