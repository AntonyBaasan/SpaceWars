class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.boolean :locked
      t.integer :stone, default: 50
      t.integer :wood, default: 50
      t.integer :population

      t.timestamps null: false
    end
  end
end
