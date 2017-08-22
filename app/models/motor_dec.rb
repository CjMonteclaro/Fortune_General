class MotorDec < ApplicationRecord

  self.table_name = "gipi_polbasic"
  self.primary_key = "policy_id"

  # Database label-substitutes
  alias_attribute :line_code, :line_cd
  alias_attribute :subline_code, :subline_cd
  alias_attribute :issue_source, :iss_cd
  alias_attribute :issue_year, :issue_yy
  alias_attribute :sequence_no, :pol_seq_no
  alias_attribute :renew_number, :renew_no

  alias_attribute :insured_no, :assd_no
  alias_attribute :effective_date, :eff_date
  alias_attribute :inception_date, :incept_date

  # Relatinship definitions
  belongs_to :assured, foreign_key: :assd_no
  belongs_to :vehicle, foreign_key: :policy_id

  def policy_no
    "#{line_code}-#{subline_code}-#{issue_source}-#{issue_year}-#{sequence_no}-#{renew_number}"
  end
end
