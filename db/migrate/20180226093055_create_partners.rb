class CreatePartners < ActiveRecord::Migration[5.0]
  def change
    create_table :partners, {:id => false} do |t|
      t.string :partner_id, :limit => 5, :null => false
      t.string :name, :limit => 80

      t.timestamps
    end
    add_index :partners, :partner_id, unique: true
  end
end
