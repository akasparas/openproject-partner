class AddContactsPartnersJoinTable < ActiveRecord::Migration[5.0]
  def self.up
    create_join_table :contacts, :partners do |t|
      t.index :contact_id
      t.index :partner_id
    end
  end

  def self.down 
    drop_table :contacts_partners
  end
end
