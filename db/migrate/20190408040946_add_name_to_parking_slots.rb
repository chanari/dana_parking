class AddNameToParkingSlots < ActiveRecord::Migration[5.2]
  def self.up
    add_column :parking_slots, :name, :string
  end

  def self.down
    add_column :parking_slots, :name
  end
end
