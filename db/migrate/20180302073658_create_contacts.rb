class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :name, limit: 50
      t.string :phone, limit: 30
      t.string :email, limit: 64

      t.timestamps
    end
  end
end
