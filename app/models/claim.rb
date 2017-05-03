class Claim < ApplicationRecord

  self.table_name = "gicl_claims"
	self.primary_key = "claim_id"

  alias_attribute :id, :claim_id
	alias_attribute :line_code, :line_cd
	alias_attribute :subline_code, :subline_cd
  alias_attribute :pol_iss_code, :pol_iss_cd
  alias_attribute :issue_year, :issue_yy
  alias_attribute :pol_seq_number, :pol_seq_no
  alias_attribute :renew_number, :renew_no
  alias_attribute :issue_code, :iss_cd
  alias_attribute :claim_year, :clm_yy
  alias_attribute :claim_seq_number, :clm_seq_no
  alias_attribute :lossdate, :loss_date
  alias_attribute :lossres_amt, :loss_res_amt
  alias_attribute :expenseres_amt, :exp_res_amt
  alias_attribute :losspd_amt, :loss_pd_amt
  alias_attribute :exppd_amt, :exp_pd_amt
  alias_attribute :status_code, :clm_stat_cd
  alias_attribute :file_date, :clm_file_date

  has_one :gicl_itemperil, foreign_key: :claim_id
  has_one :peril, through: :gicl_itemperil, foreign_key: :peril_cd, primary_key: :line_cd
  has_one :claim_status, foreign_key: :clm_stat_cd, primary_key: :clm_stat_cd

  has_many :policies, foreign_key: :line_cd

  def self.claim_search(start_date, end_date, page_no)
    self.where(file_date: start_date..end_date).where(line_code: "MC").includes(:gicl_itemperil, :peril, :claim_status).paginate(:page => page_no, :per_page => 5)
  end

  def claim_no
    "#{line_code}-#{subline_code}-#{pol_iss_code}-#{claim_year}-#{claim_seq_number}"
  end

  def line
    self.line_cd
  end

end
