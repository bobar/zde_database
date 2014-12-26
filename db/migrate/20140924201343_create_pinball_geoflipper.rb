# rubocop:disable Metrics/MethodLength
class CreatePinballGeoflipper < ActiveRecord::Migration
  def change
    create_table :pinball_geoflipper do |t|
      t.integer :pinball_id
      t.integer :bar_id
      t.string :name
      t.string :manufacturer
      t.timestamps
    end
    reversible do |dir|
      dir.up do
        execute('
          ALTER TABLE pinball_geoflipper
          ADD CONSTRAINT pinball_geoflipper_ibfk_1
          FOREIGN KEY(pinball_id)
          REFERENCES pinballs(id)
          ON DELETE SET NULL
          ON UPDATE CASCADE
        ')
        execute('
          ALTER TABLE pinball_geoflipper
          ADD CONSTRAINT pinball_geoflipper_ibfk_2
          FOREIGN KEY(bar_id)
          REFERENCES bars(id)
          ON DELETE CASCADE
          ON UPDATE CASCADE
        ')
      end
      dir.down do
        execute('
          ALTER TABLE pinball_geoflipper
          DROP FOREIGN KEY pinball_geoflipper_ibfk_1
        ')
        execute('
          ALTER TABLE pinball_geoflipper
          DROP FOREIGN KEY pinball_geoflipper_ibfk_2
        ')
      end
    end
  end
end
