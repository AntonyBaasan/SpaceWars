class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.boolean :locked
      t.integer :stone
      t.integer :wood
      t.integer :population

      t.timestamps null: false
    end
  end
end
