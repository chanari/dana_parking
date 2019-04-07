class CreateFloors < ActiveRecord::Migration[5.2]
  def change
    create_table :floors do |t|
      t.string :name
      t.string :size, limit: 1
      t.decimal :price, precision: 8, scale: 2
      t.references :parking, foreign_key: true

      t.timestamps
    end
  end
end
