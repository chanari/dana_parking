class AddParkingIdToUsers < ActiveRecord::Migration[5.2]
  def self.up
    add_column :users, :parking_id, :bigint
  end

  def self.down
    add_column :users, :parking_id
  end
end
