class AddS3ImagetoCameraView < ActiveRecord::Migration
  def change
    add_attachment :cdot_camera_camera_views, :s3_image
  end
end
