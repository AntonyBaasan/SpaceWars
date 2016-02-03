class AddCitytypeToCities < ActiveRecord::Migration
  def up
    add_column :cities, :city_type, :integer
  end
  def down
    remove_column :cities, :city_type
  end
end
