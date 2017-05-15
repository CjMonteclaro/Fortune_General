require 'csv'
include ActionView::Helpers::TextHelper
class Policy < ApplicationRecord

	self.table_name = "gipi_polbasic"
	self.primary_key = "policy_id"

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

	has_one :intermediary, through: :invoice, foreign_key: :intrmdry_intm_no

	belongs_to :assured, foreign_key: :assd_no
	has_one :line, foreign_key: :line_code
	has_one :subline, foreign_key: :subline_code

	has_one :polgenin, foreign_key: :policy_id
	has_one :endttext, foreign_key: :policy_id
	has_one :invoice
	has_one :accident_item, foreign_key: :policy_id

	has_one :item, foreign_key: :policy_id
	has_many :item_perils, foreign_key: :policy_id
	has_many :perils, through: :item_perils, foreign_key: :peril_cd
	belongs_to :vehicle, foreign_key: :policy_id
	has_one :type_of_body, through: :vehicle, foreign_key: :policy_id
	has_one :mc_car_company, through: :vehicle, foreign_key: :policy_id

	has_many :claims, foreign_key: :line_cd, primary_key: :line_cd

	def self.to_csv(start_date,end_date)
			attributes = %w{Policy/Endorsement Insured Birthday Age Inception ExpiryDate Destination DestinationClass Duration CoverageLimit Remarks}
			CSV.generate(headers: true) do |csv|
				csv << attributes
				all.each do |policy|
				csv << [policy.full_policy_no, policy.assured.assd_name,(policy.accident_item.acc_bday unless policy.accident_item.nil?),(policy.accident_item.acc_age unless policy.accident_item.nil?), policy.inc_date, policy.exp_date, (policy.accident_item&.acc_item_destination ), (policy.polgenin.travel_class unless policy.polgenin.nil?), (pluralize(policy.duration_date, 'day')), policy.polgenin&.coverage, policy.polgenin&.polgenin_gen_info1]

			end
		end
	end

	def self.to_csv1(start_date,end_date)
      attributes = %w{PolicyNo Endorsement IssueDate EffectiveDate ExpiryDate Vehicle PerilName SumInsured Premium PremiumRate}
      CSV.generate(headers: true) do |csv|
        csv << attributes
      Policy.where(acct_ent_date: start_date..end_date).where(line_code: "MC").or(self.where(spld_acct_ent_date: start_date..end_date).where(line_code: "MC")).includes(:item, :item_perils, :perils, :vehicle, :mc_car_company, :type_of_body).order('subline_cd').each do |policy|
				policy.perils.where(line_code: "MC").find_each do |peril|
					peril.item_perils.where(peril_cd: peril).find_each do |item|

        csv << [policy.policy_no, policy.endorsemnt, policy.iss_date, policy.ef_date, policy.exp_date, policy.vehicle&.vehicle_name, peril.shortname, item&.proper_tsi, item&.proper_prem, item.proper_rate ]
					end
				end
      end
    end
  end


	def self.search(search)
		if search
			@travels = Policy.where(iss_date: start_date.to_date..end_date.to_date + 1.day).where(line_code: "PA" ).where(subline_code: "TPS" ).where.not(polic_flag: ['4', '5']).includes(:assured, :item, :polgenin, :endttext, :accident_item).paginate(:page => params[:page], :per_page => 15)
    else
			limit(10)
		end
	end

	def self.search2(search2)
		if search2
			@policies = Policy.where(acct_ent_date: start_date..end_date).or(Policy.where(spld_acct_ent_date: start_date..end_date)).includes(:assured, :intermediary).order('iss_cd','line_code', 'subline_code', 'issue_year', 'sequence_no','renew_number')
       	else
			limit(10)
		end
	end

	def self.search4(search4)
		if search4
			@motor_policies = Policy.where(acct_ent_date: start_date..end_date).where(line_code: "MC").or(self.where(spld_acct_ent_date: start_date..end_date).where(line_code: "MC")).includes(:item, :item_peril, :peril, :vehicle, :mc_car_company, :type_of_body).order('subline_cd')
       	else
			limit(10)
		end
	end

	def full_policy_no
		"#{self.line_code} - #{self.subline_code} - #{self.issue_source} - #{self.issue_year} - #{self.proper_seq_no} - #{self.proper_renew_number} #{"/" if self.en_y?} #{self.en_iss_cd if self.en_y?} #{"-" if self.en_y?} #{self.en_y if self.en_y?} #{"-" if self.en_y?} #{proper_en_seq_no if self.en_y?}"
	end

	def policy_no
		"#{self.line_code} - #{self.subline_code} - #{self.issue_source} - #{self.issue_year} - #{self.proper_seq_no} - #{self.proper_renew_number}"
	end

	def endorsemnt
		"#{self.en_iss_cd} - #{ self.proper_en_y } - #{  proper_en_seq_no  }"
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

	def duration_date
		(self.exp_date - self.ef_date).to_i + 1
	end

	def self.motor_search(start_date, end_date, page_no)
		self.where(acct_ent_date: start_date..end_date).where(line_code: "MC").or(self.where(spld_acct_ent_date: start_date..end_date).where(line_code: "MC")).includes(:item, :item_perils, :perils, :vehicle, :mc_car_company, :type_of_body).paginate(:page => page_no, :per_page => 5)
	end

	# def self.peril_conditon
	# 	Peril.line_code == Item_Peril.line_code
	# 	Item_Peril.peril_code == Peril.peril_code
	# end

end
