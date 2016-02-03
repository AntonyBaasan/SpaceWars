class AddLastFightDatetimeToCities < ActiveRecord::Migration
  def up
    add_column :cities, :last_fight_date, :datetime, default: Time.now
  end
  def down
    remove_column :cities, :last_fight_date
  end
end
