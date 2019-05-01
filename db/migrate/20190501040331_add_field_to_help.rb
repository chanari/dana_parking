class AddFieldToHelp < ActiveRecord::Migration[5.2]
  def self.up
    add_column :helpers, :is_read, :boolean, default: false
  end

  def self.down
    remove_column :helpers, :is_read
  end
end
