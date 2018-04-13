module CdotCamera
  class CameraView < ActiveRecord::Base
    self.table_name = "cdot_camera_camera_views"

    belongs_to :camera
  end
end
