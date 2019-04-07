class ModifyFloorsFields < ActiveRecord::Migration[5.2]
  def self.up
    remove_column :floors, :price
    add_column :floors, :price_by_hours, :decimal, precision: 8, scale: 2
    add_column :floors, :price_by_months, :decimal, precision: 8, scale: 2
  end

  def self.down
    add_column :floors, :price, :decimal, precision: 8, scale: 2
    remove_column :floors, :price_by_hours
    remove_column :floors, :price_by_months
  end
end
