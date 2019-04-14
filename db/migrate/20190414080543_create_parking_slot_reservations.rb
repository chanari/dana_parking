class CreateParkingSlotReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :parking_slot_reservations do |t|
      t.string :number_plate
      t.datetime :timein
      t.datetime :timeout
      t.boolean :is_paid
      t.references :user, foreign_key: true
      t.references :parking_slot, foreign_key: true

      t.timestamps
    end
  end
end
