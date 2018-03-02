class ChangeContactsColumnWidths < ActiveRecord::Migration[5.0]
  def change
    change_column :contacts, :name, :string, limit: 50
    change_column :contacts, :phone, :string, limit: 30
    change_column :contacts, :email, :string, limit: 64
  end
end
