class Partner < ApplicationRecord
    has_and_belongs_to_many :items
    has_and_belongs_to_many :contacts
    self.primary_key = :partner_id
    
    scope :sorted_alphabetically, -> { order("partner_id, name") }

    def new_contact
    end

end
