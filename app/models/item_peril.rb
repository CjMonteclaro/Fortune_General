class ItemPeril < ApplicationRecord

  self.table_name = "gipi_itmperil"
  self.primary_key = "policy_id"

  alias_attribute :pol_id, :policy_id
  alias_attribute :itm_no, :item_no
  alias_attribute :rate, :prem_rt
  alias_attribute :tsi, :tsi_amt
  alias_attribute :prem, :prem_amt
  alias_attribute :peril_code, :peril_cd
  alias_attribute :line_code, :line_cd

  belongs_to :policy, foreign_key: :policy_id
  belongs_to :item, foreign_key: :item_no
  has_one :peril, foreign_key: :peril_code

end
