class Line < ApplicationRecord

  	self.table_name = "giis_line"
  	self.primary_key = "line_cd"

  	alias_attribute :line_code, :line_cd
  	alias_attribute :lin_name, :line_name

    belongs_to :policy

end
