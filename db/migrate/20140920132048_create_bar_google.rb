# rubocop:disable Metrics/MethodLength
class CreateBarGoogle < ActiveRecord::Migration
  def change
    create_table :bar_google do |t|
      t.integer :bar_id
      t.string :name
      t.string :address
      t.float :rating
      t.float :latitude
      t.float :longitude
      t.string :types
      t.string :place_id
      t.string :old_id
      t.timestamps
    end
    reversible do |dir|
      dir.up do
        execute('
          ALTER TABLE bar_google
          ADD CONSTRAINT bar_google_ibfk_1
          FOREIGN KEY(bar_id)
          REFERENCES bars(id)
          ON DELETE CASCADE
          ON UPDATE CASCADE
        ')
      end
      dir.down do
        execute('
          ALTER TABLE bar_google
          DROP FOREIGN KEY bar_google_ibfk_1
        ')
      end
    end
  end
end
