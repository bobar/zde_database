class CreatePinballs < ActiveRecord::Migration
  def change
    create_table :pinballs do |t|
      t.string :name
      t.string :manufacturer
      t.integer :year
    end
  end
end
