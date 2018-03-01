class AddPartnerRefToProject < ActiveRecord::Migration[5.0]
  def change
    add_reference :projects, :partner, foreign_key: false, type: :string, limit: 5
  end
end
