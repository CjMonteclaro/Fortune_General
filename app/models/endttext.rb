class Endttext < ApplicationRecord

	self.table_name = "gipi_endttext"
	self.primary_key = "policy_id"

	alias_attribute :endt_txt, :endt_text01
	alias_attribute :endt_pol_id, :policy_id

	belongs_to :policy, foreign_key: :policy_id
end
