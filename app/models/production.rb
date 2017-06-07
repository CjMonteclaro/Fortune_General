class Production < ApplicationRecord

  self.table_name = "giis_intermediary"
	self.primary_key = "intm_no"

	alias_attribute :name, :intm_name
	alias_attribute :no, :intm_no
  alias_attribute :type, :intm_type
  alias_attribute :iss_source, :iss_cd

	has_many :invoices, foreign_key: :intrmdry_intm_no
	has_many :policies, through: :invoices, foreign_key: :policy_id
  has_one :issource, foreign_key: :iss_cd, primary_key: :iss_cd

  def issue_source
    if self.iss_cd == self.issource.iss_cd
      self.issource.iss_name
    end
  end

  def self.total_prem
    Policy.sum(:pre_amt)
  end

end
