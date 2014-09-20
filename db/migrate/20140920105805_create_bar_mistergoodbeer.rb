class CreateBarMistergoodbeer < ActiveRecord::Migration
  def change
    create_table :bar_mistergoodbeer do |t|
      t.integer :bar_id
      t.string :url
      t.string :name
      t.string :address
      t.float :price
      t.float :hh_price
      t.string :hh_open
      t.string :hh_close
      t.timestamps
    end
    reversible do |dir|
      dir.up do
        execute 'ALTER TABLE bar_mistergoodbeer ADD CONSTRAINT bar_mistergoodbeer_ibfk_1
          FOREIGN KEY(bar_id) REFERENCES bars(id) ON DELETE CASCADE ON UPDATE CASCADE'
      end
      dir.down do
        execute 'ALTER TABLE bar_mistergoodbeer DROP FOREIGN KEY bar_mistergoodbeer_ibfk_1'
      end
    end
  end
end
