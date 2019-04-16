class CreateVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicles do |t|
      t.string :number_plate
      t.string :vehicle_name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
