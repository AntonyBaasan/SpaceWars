class AddMaxColumnsToCities < ActiveRecord::Migration
  def up
    add_column :cities, :max_building_amount, :integer, default: 20
    add_column :cities, :max_army_amount, :integer, default: 20
  end
  def down
    remove_column :cities, :max_building_amount
    remove_column :cities, :max_army_amount
  end
end
