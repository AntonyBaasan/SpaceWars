class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.integer :collect_minute
      t.date :last_collect
      t.integer :amount
      t.string :resource_type
      t.references :city

      t.timestamps null: false
    end
  end
end
