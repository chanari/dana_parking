class AddTypeToReserve < ActiveRecord::Migration[5.2]
  def self.up
    add_column :parking_slot_reservations, :type, :string, :default => 'Ngày'
  end

  def self.down
    remove_column :parking_slot_reservations, :type
  end
end
