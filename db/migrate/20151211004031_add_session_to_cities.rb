class AddSessionToCities < ActiveRecord::Migration
  def change
    add_column :cities, :session_id, :string
  end
end
