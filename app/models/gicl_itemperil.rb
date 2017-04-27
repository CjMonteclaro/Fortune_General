class GiclItemperil < ApplicationRecord

  self.table_name = "gicl_item_peril"
	self.primary_key = "peril_cd"

	alias_attribute :peril_code, :peril_cd
	alias_attribute :line_code, :line_cd
	alias_attribute :id, :claim_id

  belongs_to :claim, foreign_key: :claim_id
  belongs_to :peril, primary_key: :peril_cd

end
