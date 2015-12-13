class AddIndexCitiesColumnCCityhash < ActiveRecord::Migration
  def change
    add_index :cities, :city_hash
  end
end
