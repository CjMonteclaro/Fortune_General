class Issource < ApplicationRecord

  self.table_name = "giis_issource"
  self.primary_key = "iss_cd"

  alias_attribute :issue_code, :iss_cd
  alias_attribute :issue_name, :iss_name

  belongs_to :policy, foreign_key: :iss_cd, primary_key: :iss_cd

end
