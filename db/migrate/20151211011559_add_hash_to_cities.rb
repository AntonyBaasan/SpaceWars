class AddHashToCities < ActiveRecord::Migration
  def up
    add_column :cities, :city_hash, :string
    remove_column :cities, :session_id
  end

  def down
    remove_column :cities, :city_hash
    add_column :cities, :session_id, :string
  end

end
