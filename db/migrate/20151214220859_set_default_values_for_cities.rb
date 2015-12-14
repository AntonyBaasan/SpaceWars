class SetDefaultValuesForCities < ActiveRecord::Migration
  def change
    change_column :cities, :population, :integer, :default => 0
    change_column :cities, :wood, :integer, :default => 50
    change_column :cities, :stone, :integer, :default => 50
  end
end
