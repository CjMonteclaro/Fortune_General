class AccidentItem < ApplicationRecord

	self.table_name = "gipi_accident_item"
	self.primary_key = "policy_id"

	alias_attribute :acc_item_pol_id, :policy_id
	alias_attribute :acc_item_number, :item_no
	alias_attribute :acc_bday, :date_of_birth
	alias_attribute :acc_age, :age
	alias_attribute :acc_item_destination, :destination

	has_one :item, foreign_key: :item_no
	belongs_to :policy, foreign_key: :policy_id

	def destination_class
		/schengen|worldwide|asian/i.match(acc_item_destination).to_s
	end

end
