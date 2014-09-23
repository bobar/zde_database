# rubocop:disable Metrics/MethodLength
class CreatePinballIpdb < ActiveRecord::Migration
  def change
    create_table :pinball_ipdb do |t|
      t.integer :ipdb_id
      t.integer :pinball_id
      t.string :name
      t.string :manufacturer
      t.integer :year
      t.float :rating
      t.float :rating_art
      t.float :rating_audio
      t.float :rating_playfield
      t.float :rating_gameplay
      t.integer :ratings
    end
    add_index :pinball_ipdb, :ipdb_id, unique: true
    reversible do |dir|
      dir.up do
        execute('
          ALTER TABLE pinball_ipdb
          ADD CONSTRAINT pinball_ipdb_ibfk_1
          FOREIGN KEY(pinball_id)
          REFERENCES pinballs(id)
          ON DELETE SET NULL
          ON UPDATE CASCADE
        ')
      end
      dir.down do
        execute('
          ALTER TABLE pinball_ipdb
          DROP FOREIGN KEY pinball_ipdb_ibfk_1
        ')
      end
    end
  end
end
