class AddFieldToParkingslots < ActiveRecord::Migration[5.2]
  def self.up
    add_column :parking_slots, :client, :bigint
  end

  def self.down
    remove_column :parking_slots, :client
  end
end
