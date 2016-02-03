class AddColumnsToCity < ActiveRecord::Migration
  def change
    add_column :cities, :win, :integer, default: 0
    add_column :cities, :lose, :integer, default: 0
  end
end
