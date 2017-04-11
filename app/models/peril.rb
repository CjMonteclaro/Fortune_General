class Peril < ApplicationRecord
  self.table_name = "giis_peril"
  self.primary_key = "line_cd"

  alias_attribute :peril_code, :peril_cd
  alias_attribute :line_code, :line_cd
  alias_attribute :peril_snam, :peril_sname
  alias_attribute :peril_nam, :peril_name

  belongs_to :item_peril, foreign_key: :peril_code
  belongs_to :policy, foreign_key: :line_code

end
