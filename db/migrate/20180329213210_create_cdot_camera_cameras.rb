class CreateCdotCameraCameras < ActiveRecord::Migration
  def change
    create_table :cdot_camera_cameras do |t|
      t.string :name
      t.string :description
      t.float :latitude
      t.float :longitude
      t.string :source
      t.string :icon
      t.integer :status
      t.boolean :weather_station
      t.integer :cdot_camera_id

      t.timestamps null: false
    end
  end
end
