class CreateParkingSlots < ActiveRecord::Migration[5.2]
  def change
    create_table :parking_slots do |t|
      t.string :status, limit: 1
      t.datetime :date_in
      t.references :floor, foreign_key: true

      t.timestamps
    end
  end
end
