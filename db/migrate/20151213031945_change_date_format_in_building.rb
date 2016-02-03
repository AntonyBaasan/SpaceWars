class ChangeDateFormatInBuilding < ActiveRecord::Migration
  def up
    change_column :buildings, :last_collect, :datetime
  end

  def down
    change_column :buildings, :last_collect, :date
  end
end
