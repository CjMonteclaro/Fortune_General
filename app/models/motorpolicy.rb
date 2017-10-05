require 'csv'
include ActionView::Helpers::TextHelper
class Motorpolicy < ApplicationRecord

	self.table_name = "gipi_polbasic"
	self.primary_key = :policy_id
	# , :line_cd, :subline_cd, :iss_cd, :issue_yy, :pol_seq_no, :renew_no
	# self.primary_key = "policy_id", "line_cd", "subline_cd", "iss_cd", "issue_yy", "pol_seq_no", "renew_no"

	alias_attribute :pol_id, :policy_id
	alias_attribute :iss_date, :issue_date
	alias_attribute :ef_date, :eff_date
	alias_attribute :inc_date, :incept_date
	alias_attribute :exp_date, :expiry_date
	alias_attribute :ts_amt, :tsi_amt
	alias_attribute :pre_amt, :prem_amt
	alias_attribute :pol_assurd_no, :assd_no
	alias_attribute :credit_branch, :cred_branch
	alias_attribute :acct_ent, :acct_ent_date
	alias_attribute :spld_ent_date, :spld_acct_ent_date
	alias_attribute :line_code, :line_cd
	alias_attribute :subline_code, :subline_cd
	alias_attribute :issue_source, :iss_cd
	alias_attribute :issue_year, :issue_yy
	alias_attribute :sequence_no, :pol_seq_no
	alias_attribute :renew_number, :renew_no
	alias_attribute :en_iss_cd, :endt_iss_cd
	alias_attribute :en_y, :endt_yy
	alias_attribute :en_seq_no, :endt_seq_no
	alias_attribute :polic_flag, :pol_flag
	alias_attribute :spoiled_flag, :spld_flag

	has_one :intermediary, through: :invoice, foreign_key: :intm_no
	has_one :issource, foreign_key: :iss_cd, primary_key: :iss_cd

	belongs_to :assured, foreign_key: :assd_no
	has_many :lines, foreign_key: :line_cd, primary_key: :line_cd
	has_one :subline, foreign_key: :subline_code

	has_one :polgenin, foreign_key: :policy_id
	has_one :endttext, foreign_key: :policy_id
	has_one :invoice, foreign_key: :policy_id, primary_key: :policy_id
	has_one :accident_item, foreign_key: :policy_id

	has_one :item, foreign_key: :policy_id
	has_many :item_perils, foreign_key: :policy_id
	has_many :perils, through: :item_perils, foreign_key: :peril_cd
	belongs_to :vehicle, foreign_key: :policy_id
	has_one :type_of_body, through: :vehicle, foreign_key: :policy_id
	has_one :mc_car_company, through: :vehicle, foreign_key: :policy_id

	# has_many :claims, :foreign_key => [:line_cd, :subline_cd, :pol_iss_cd, :issue_yy, :pol_seq_no, :renew_no]

	has_one :production, through: :invoice, foreign_key: :intm_no

	scope :filter_date, -> (start_date, end_date){ where(acct_ent: start_date..end_date).or(where(spld_ent_date: start_date..end_date ))   }
	scope :order_by_line_cd, -> { order(line_cd: :asc)   }

	def self.motor_to_csv(start_date,end_date)
      attributes = %w{PolicyNo Endorsement IssueDate EffectiveDate ExpiryDate Vehicle PerilName SumInsured Premium PremiumRate}
      CSV.generate(headers: true) do |csv|
        csv << attributes
      Motorpolicy.where(acct_ent_date: start_date..end_date, line_code: "MC").or(Motorpolicy.where(spld_acct_ent_date: start_date..end_date, line_code: "MC")).includes(:item, :item_perils, :perils, :vehicle, :mc_car_company, :type_of_body).order('subline_cd,iss_cd,pol_seq_no,renew_no').each do |policy|
				policy.perils.where(line_code: "MC").find_each do |peril|
					policy.item_perils.where(peril_cd: peril).find_each do |item|

        csv << [policy.policy_no, policy.endorsemnt, policy.iss_date, policy.ef_date, policy.exp_date, policy.vehicle&.vehicle_name, peril.shortname, item&.proper_tsi, item&.proper_prem, item.proper_rate ]
					end
				end
      end
    end
  end

	def self.search_motor(search_motor)
		if search_motor
			@motor_policies = self.where(acct_ent_date: start_date..end_date, line_code: "MC").or(self.where(spld_acct_ent_date: start_date..end_date, line_code: "MC")).includes(:item, :item_perils, :perils, :vehicle, :mc_car_company, :type_of_body).order('subline_cd,iss_cd,pol_seq_no,renew_no')
    else
			limit(10)
		end
	end

	def self.search_date(start_date,end_date)
	  self.where(acct_ent_date: start_date..end_date).or(self.where(spld_acct_ent_date: start_date..end_date)).joins(:lines, :issource, :invoice, :intermediary)
	end

	def self.motors_search(start_date, end_date)
		Motorpolicy.where(acct_ent_date: start_date..end_date, line_code: "MC").or(Motorpolicy.where(spld_acct_ent_date: start_date..end_date, line_code: "MC")).includes(:item, :item_perils, :perils, :vehicle, :mc_car_company, :type_of_body).order('subline_cd,iss_cd,pol_seq_no,renew_no')
	end

	def full_policy_no
		"#{self.line_code} - #{self.subline_code} - #{self.issue_source} - #{self.issue_year} - #{self.proper_seq_no} - #{self.proper_renew_number} #{"/" if self.en_y?} #{self.en_iss_cd if self.en_y?} #{"-" if self.en_y?} #{self.en_y if self.en_y?} #{"-" if self.en_y?} #{proper_en_seq_no if self.en_y?}"
	end

	def policy_no #for motorcar, connect or match with claims_no
		"#{self.line_code} - #{self.subline_code} - #{self.issue_source} - #{self.issue_year} - #{self.proper_seq_no} - #{self.proper_renew_number}"
	end

	def pol_claim
		self.policy_no == Claim.claim_no
	end

	def endorsemnt
		"#{self.en_iss_cd if self.en_y?} - #{self.proper_en_y if self.en_y?} #{"-" if self.en_y?} #{proper_en_seq_no if self.en_y?}"
	end

	def proper_seq_no
		 case sequence_no.to_s.length
		when 1
		 proper_seq_no = "000000" + sequence_no.to_s
		when 2
		 proper_seq_no = "00000" + sequence_no.to_s
		when 3
		 proper_seq_no = "0000" + sequence_no.to_s
		when 4
		 proper_seq_no = "000" + sequence_no.to_s
		when 5
		 proper_seq_no = "00" + sequence_no.to_s
		when 6
		 proper_seq_no = "0" + sequence_no.to_s
		end
	end

	def proper_renew_number
		case renew_number.to_s.length
		when 1
		 proper_renew_number = "0" + renew_number.to_s
	 	when 2
	 	proper_renew_number = " " + renew_number.to_s
		when nil?
		 proper_renew_number = "00"
		end
	end

	def proper_en_y
		prop_en_y = en_y.to_s.to_s.delete(' ')
		 case prop_en_y.to_s.length
		when 1
		 proper_en_y = "0" + en_y.to_s.to_s.delete(' ')
	 when 2
	 		proper_en_y = " " + en_y.to_s.to_s.delete(' ')
		when nil?
		 proper_en_y = "00"
		end
	end

	def proper_en_seq_no
		prop_en_seq_no = en_seq_no.to_s.delete(' ')
		case prop_en_seq_no.to_s.length
		when 1
		 proper_en_seq_no = "000000" + en_seq_no.to_s.delete(' ')
		when 2
		 proper_en_seq_no = "00000" + en_seq_no.to_s.delete(' ')
		when 3
		 proper_en_seq_no = "0000" + en_seq_no.to_s.delete(' ')
		when 4
		 proper_en_seq_no = "000" + en_seq_no.to_s.delete(' ')
		when 5
		 proper_en_seq_no = "00" + en_seq_no.to_s.delete(' ')
		when 6
		 proper_en_seq_no = "0" + en_seq_no.to_s.delete(' ')
		when nil?
		 proper_en_seq_no = "0000000"
		end
	end

	def issue_src
    if (if self.cred_branch.nil? then self.iss_cd else self.cred_branch end) == self.issource.iss_cd
      self.issource.iss_name
    end
  end

	def duration_date
		(self.exp_date - self.ef_date).to_i + 1
	end


end
