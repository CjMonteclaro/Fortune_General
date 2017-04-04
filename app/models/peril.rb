class Peril < ApplicationRecord
  self.table_name = "giis_peril"
  self.primary_key = "line_cd"

  alias_attribute :peril_code, :peril_cd
  alias_attribute :line_code, :line_cd
  alias_attribute :peril_nam, :peril_sname

  belongs_to :item_peril

end
