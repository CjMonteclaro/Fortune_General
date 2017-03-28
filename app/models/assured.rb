class Assured < ApplicationRecord

	self.table_name = "giis_assured"
	self.primary_key = "assd_no"

	alias_attribute :assd_num, :assd_no
	alias_attribute :assd_nam1, :assd_name
	alias_attribute :assd_nam2, :assd_name2

	has_many :policies, foreign_key: :policy_id

	def complete_assd_name
		"#{self.assd_nam1} #{self.assd_nam2}"
	end

end
