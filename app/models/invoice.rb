class Invoice < ApplicationRecord
	self.table_name = "gipi_comm_invoice"
	self.primary_key = "intrmdry_intm_no"
	# self.primary_key = "iss_cd"
	# self.primary_key = "prem_seq_no"

	alias_attribute :intm_no, :intrmdry_intm_no
	alias_attribute :pol_id, :policy_id

	belongs_to :policy, foreign_key: :policy_id
	belongs_to :intermediary, foreign_key: :intrmdry_intm_no


end
