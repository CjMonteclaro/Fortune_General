class ClaimStatus < ApplicationRecord

    self.table_name = "giis_clm_stat"
  	self.primary_key = "clm_stat_cd"

  	alias_attribute :description, :clm_stat_desc
  	alias_attribute :satus_code, :clm_stat_cd

    belongs_to :claim, foreign_key: :clm_stat_cd, primary_key: :clm_stat_cd

end
