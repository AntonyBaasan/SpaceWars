class AddChangeUnitColumnName < ActiveRecord::Migration
  def up
    remove_column :units, :type
    add_column :units, :unit_type, :integer
  end
  def down
    add_column :units, :type, :integer
    remove_column :units, :unit_type
  end
end
