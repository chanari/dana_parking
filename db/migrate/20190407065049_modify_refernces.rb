class ModifyRefernces < ActiveRecord::Migration[5.2]
  def self.up
    remove_reference :parking_slots, :floor, foreign_key: true
    add_reference :parking_slots, :block, foreign_key: true
  end

  def self.down
    add_reference :parking_slots, :floor, foreign_key: true
    remove_reference :parking_slots, :block, foreign_key: true
  end
end
