class ChangeNameColumnCities < ActiveRecord::Migration
  def change
    change_column :cities, :name, :string, :limit => 25
  end
end
