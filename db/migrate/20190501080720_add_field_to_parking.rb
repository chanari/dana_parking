class AddFieldToParking < ActiveRecord::Migration[5.2]
  def self.up
    add_column :parkings, :active, :boolean, default: true
  end

  def self.down
    add_column :parkings, :active
  end
end
