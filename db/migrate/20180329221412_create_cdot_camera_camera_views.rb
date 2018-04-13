class CreateCdotCameraCameraViews < ActiveRecord::Migration
  def change
    create_table :cdot_camera_camera_views do |t|
      t.string :name
      t.string :description
      t.string :source
      t.string :direction
      t.string :image_location
      t.string :road_name
      t.integer :cdot_camera_id
      t.integer :cdot_view_id
      t.integer :display_order
      t.integer :road_id
      t.integer :mile_marker
      t.datetime :last_updated_at

      t.timestamps null: false
    end
  end
end
