class ChangeContactsPartnersIdType < ActiveRecord::Migration[5.0]
  def change
    change_column :contacts_partners, :partner_id, :string, limit: 5
  end
end
