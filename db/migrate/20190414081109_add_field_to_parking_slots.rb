class AddFieldToParkingSlots < ActiveRecord::Migration[5.2]
  def self.up
    add_column :parking_slots, :number_plate, :string
  end

  def self.down
    remove_column :parking_slots, :number_plate
  end
end
