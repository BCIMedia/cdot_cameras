module CdotCamera
  class Camera < ActiveRecord::Base
    self.table_name = "cdot_camera_cameras"
    has_many :camera_views
  end
end
