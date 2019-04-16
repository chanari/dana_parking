class AddPrice < ActiveRecord::Migration[5.2]
  def self.up
    add_column :parking_slot_reservations, :price, :integer
    add_column :parking_slot_reservations, :subtotal, :integer
  end

  def self.down
    remove_column :parking_slot_reservations, :price
    remove_column :parking_slot_reservations, :subtotal
  end
end
