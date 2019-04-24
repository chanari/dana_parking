class AddTypeToReserve < ActiveRecord::Migration[5.2]
  def self.up
    add_column :parking_slot_reservations, :is_monthly, :boolean, :default => false
    add_column :parking_slot_reservations, :park_id, :bigint
  end

  def self.down
    remove_column :parking_slot_reservations, :is_monthly
    remove_column :parking_slot_reservations, :park_id
  end
end
