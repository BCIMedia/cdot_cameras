class CreateCdotCameraCameraViews < ActiveRecord::Migration
  def change
    create_table :cdot_camera_camera_views do |t|
      t.string :name
      t.string :description
      t.string :source
      t.integer :cdot_view_id
      t.integer :direction
      t.string :image_location
      t.integer :display_order
      t.string :road_name
      t.integer :road_id
      t.datetime :last_updated_at

      t.timestamps null: false
    end
  end
end
