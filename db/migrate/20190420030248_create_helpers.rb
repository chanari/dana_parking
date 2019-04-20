class CreateHelpers < ActiveRecord::Migration[5.2]
  def change
    create_table :helpers do |t|
      t.string :name
      t.text :content
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
