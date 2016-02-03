class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name
      t.integer :type
      t.integer :attack
      t.integer :defence

      t.timestamps null: false
    end
  end
end
