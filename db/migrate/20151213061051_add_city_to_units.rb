class AddCityToUnits < ActiveRecord::Migration
  def change
    add_reference :units, :city, index: true
  end
end
