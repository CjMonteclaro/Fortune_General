class Invoice < ApplicationRecord
	self.table_name = "gipi_comm_invoice"
	self.primary_key = "intrmdry_intm_no"

	alias_attribute :intm_no, :intrmdry_intm_no
	alias_attribute :pol_id, :policy_id

	belongs_to :policy
	belongs_to :intermediary, foreign_key: :intrmdry_intm_no

end
