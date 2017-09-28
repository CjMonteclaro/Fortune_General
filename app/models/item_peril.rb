class ItemPeril < ApplicationRecord

  self.table_name = "gipi_itmperil"
  self.primary_key = "item_no"

  alias_attribute :pol_id, :policy_id
  alias_attribute :itm_no, :item_no
  alias_attribute :rate, :prem_rt
  alias_attribute :tsi, :tsi_amt
  alias_attribute :prem, :prem_amt
  alias_attribute :peril_code, :peril_cd
  alias_attribute :line_code, :line_cd

  belongs_to :policy, foreign_key: :policy_id
  belongs_to :motorpolicy, foreign_key: :policy_id
  belongs_to :item, foreign_key: :item_no
  belongs_to :peril, foreign_key: :peril_cd

  # has_one :peril, foreign_key: :peril_code

  def self.applicable_rate
    self.rate.present? ? rate : "0.0"
    # if policy.item_peril.rate.nil? then "0.0" end || if policy.item_peril.rate.present? then policy.item_peril.rate end
  end

  def proper_tsi
    proper_tsi = (tsi.to_i * -1)
  end

  def proper_prem
    proper_prem = (prem.to_i * -1)
  end

  def proper_rate
    proper_rate = rate
  end

end
