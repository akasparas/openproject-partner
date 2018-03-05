class Contact < ApplicationRecord
    has_and_belongs_to_many :partners

    scope :sorted_alphabetically, -> { order("name, phone, email") }

    def new_partner
    end
end
