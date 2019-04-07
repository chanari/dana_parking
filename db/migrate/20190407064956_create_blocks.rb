class CreateBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :blocks do |t|
      t.string :name
      t.references :floor, foreign_key: true

      t.timestamps
    end
  end
end
