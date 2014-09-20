# rubocop:disable Metrics/MethodLength
class CreateBars < ActiveRecord::Migration
  def change
    create_table :bars do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.float :price
      t.string :open
      t.string :close
      t.float :hh_price
      t.string :hh_open
      t.string :hh_close
      t.timestamps
    end
  end
end
