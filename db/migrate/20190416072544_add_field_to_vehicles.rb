class AddFieldToVehicles < ActiveRecord::Migration[5.2]
  def self.up
    add_column :vehicles, :vehicle_type, :string
  end

  def self.down
    remove_column :vehicles, :vehicle_type
  end
end
