class Subline < ApplicationRecord

  	self.table_name = "giis_subline"
  	self.primary_key = "line_cd"

  	alias_attribute :line_code, :line_cd
  	alias_attribute :subline_code, :subline_cd
  	alias_attribute :subline_nam, :subline_name

    belongs_to :policy

end
