class Peril < ApplicationRecord
  self.table_name = "giis_peril"
  self.primary_key = "peril_cd"

  alias_attribute :peril_code, :peril_cd
  alias_attribute :line_code, :line_cd
  alias_attribute :shortname, :peril_sname
  alias_attribute :name, :peril_name

  has_many :item_perils, foreign_key: :peril_cd
  has_many :policies, through: :item_perils, foreign_key: :policy_id

end
