class AddIndexToBuildingsAndUnits < ActiveRecord::Migration
  def change
    add_index :buildings, :city_id
  end
end
