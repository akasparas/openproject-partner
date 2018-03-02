class Partner < ApplicationRecord
    has_and_belongs_to_many :items
    self.primary_key = :partner_id
end
