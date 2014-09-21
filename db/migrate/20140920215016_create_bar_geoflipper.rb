class CreateBarGeoflipper < ActiveRecord::Migration
  def change
    create_table :bar_geoflipper do |t|
      t.integer :bar_id
      t.string :name
      t.string :url
      t.float :latitude
      t.float :longitude
    end
    add_index :bar_geoflipper, :url, unique: true
  end
end
