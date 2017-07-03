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

	has_many :claims, foreign_key: :line_cd, primary_key: :line_cd

	has_one :production, through: :invoice, foreign_key: :intm_no

	scope :filter_date, -> (start_date, end_date){ where(acct_ent: start_date..end_date).or(where(spld_ent_date: start_date..end_date ))   }

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

	def self.intm_prod_csv(start_date,end_date)
			attributes = %w{INTM INTM_NO INTM_TYPE ISS_NAME PA AH CA EN FI MC MH MN SU AV PREM}
			CSV.generate(headers: true) do |csv|
				csv << attributes
			# Policy.where(acct_ent_date: start_date..end_date).or(Policy.where(spld_acct_ent_date: start_date..end_date)).joins(:lines,:issource,:invoice,:intermediary).order('giis_intermediary.intm_name','giis_issource.iss_name').group('giis_intermediary.intm_name','giis_intermediary.intm_no','giis_intermediary.intm_type','giis_issource.iss_name').sum(:pre_amt)
			pols = Policy.where(acct_ent_date: start_date..end_date).or(Policy.where(spld_acct_ent_date: start_date..end_date)).joins(:lines, :issource, :invoice,:intermediary).order('giis_intermediary.intm_name','giis_issource.iss_name').group('giis_intermediary.intm_name','giis_intermediary.intm_no','giis_intermediary.intm_type','giis_issource.iss_name').sum(:pre_amt)
			pols.each do | intm_name, intm_no, intm_type, iss_name, pre_amt |

				# csv <<  [ policy.intermediary.intm_name, policy.intermediary.intm_no, policy.intermediary.intm_type, policy.issource.iss_name, policy.linecd_pa, policy.linecd_ah, policy.linecd_ca, policy.linecd_en, policy.linecd_fi, policy.linecd_mc, policy.linecd_mh, policy.linecd_mn, policy.linecd_su, policy.linecd_av, policy.pre_amt]
				csv <<  [ intm_name, intm_no, intm_type, iss_name, pre_amt ]

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

	def self.intm_prod_search(intm_prod_search)
		if intm_prod_search
			@intermediary_productions = self.where(acct_ent_date: start_date..end_date).or(self.where(spld_acct_ent_date: start_date..end_date)).joins(:lines, :issource, :invoice, :intermediary)
			#.order('giis_intermediary.intm_name','giis_issource.iss_name').group('giis_intermediary.intm_name','giis_intermediary.intm_no','giis_intermediary.intm_type','giis_issource.iss_name').sum(:pre_amt)
			# @intermediary_productions_view = self.where(acct_ent_date: start_date..end_date).or(self.where(spld_acct_ent_date: start_date..end_date)).joins(:lines, :issource, :invoice, :intermediary).order('giis_intermediary.intm_name','giis_issource.iss_name')
		end
	end

	def self.search_date(start_date,end_date)
	  self.where(acct_ent_date: start_date..end_date).or(self.where(spld_acct_ent_date: start_date..end_date)).joins(:lines, :issource, :invoice, :intermediary)
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

	def int_prem_amt
	#  @intermediary_productions_view&.sum(:prem_amt)
	 if self.line_code == "PA"
		 int_prem_amt = @intermediary_productions&.prem_amt
	 else
	 	 0
	 end
	 if self.line_code == "AH"
		 int_prem_amt = @intermediary_productions&.prem_amt
	 else
		 0
	 end
	 if self.line_code == "CA"
		 int_prem_amt = @intermediary_productions&.prem_amt
	 else
		 0
	 end
	 if self.line_code == "EN"
		 int_prem_amt = @intermediary_productions&.prem_amt
   else
		   0
   end
	 if self.line_code == "FI"
	   int_prem_amt = @intermediary_productions&.prem_amt
   else
	   0
   end
   if self.line_code == "MC"
	   int_prem_amt = @intermediary_productions&.prem_amt
   else
		 0
	 end
	 if self.line_code == "MH"
		 int_prem_amt = @intermediary_productions&.prem_amt
	 else
		 0
	 end
	 if self.line_code == "MN"
		 int_prem_amt = @intermediary_productions&.prem_amt
	 else
		 0
	 end
	 if self.line_code == "SU"
		 int_prem_amt = @intermediary_productions&.prem_amt
	 else
		 0
	 end
	 if self.line_code == "AV"
		 int_prem_amt = @intermediary_productions&.prem_amt
	 else
		 0
	 end

	end

	def linecd_pa
		# @pols = Policy.where(acct_ent_date: start_date..end_date).or(Policy.where(spld_acct_ent_date: start_date..end_date)).joins(:lines, :issource, :invoice,:intermediary).order('giis_intermediary.intm_name','giis_issource.iss_name'
		if self.line_code == "PA"
			self.int_prem_amt
			# Policy.sum(:prem_amt).group('giis_intermediary.intm_name')
			# Policy.select(Arel::Nodes::NamedFunction.new('SUM', [Arel::Nodes::NamedFunction.new('DECODE', [:line_cd, 'PA', :prem_amt, 0])]))
		else
			"0"
		end

	end

	def linecd_ah
		if self.line_code == "AH"
			self.int_prem_amt
			# Policy.select(Arel::Nodes::NamedFunction.new('SUM', [Arel::Nodes::NamedFunction.new('DECODE', [:line_cd, 'PA', :prem_amt, 0])]))
		else
			"0"
		end
	end

	def linecd_ca
		if self.line_code == "CA"
			self.int_prem_amt
			# Policy.select(Arel::Nodes::NamedFunction.new('SUM', [Arel::Nodes::NamedFunction.new('DECODE', [:line_cd, 'CA', :prem_amt, 0])]))
		else
			"0"
		end
	end

	def linecd_en
		if self.line_code == "EN"
			self.int_prem_amt
			# Policy.select(Arel::Nodes::NamedFunction.new('SUM', [Arel::Nodes::NamedFunction.new('DECODE', [:line_cd, 'EN', :prem_amt, 0])]))
		else
			"0"
		end
	end

	def linecd_fi
		if self.line_code == "FI"
			self.int_prem_amt
			# Policy.select(Arel::Nodes::NamedFunction.new('SUM', [Arel::Nodes::NamedFunction.new('DECODE', [:line_cd, 'FI', :prem_amt, 0])]))
		else
			"0"
		end
	end

	def linecd_mc
		if self.line_code == "MC"
			self.int_prem_amt
			# Policy.select(Arel::Nodes::NamedFunction.new('SUM', [Arel::Nodes::NamedFunction.new('DECODE', [:line_cd, 'MC', :prem_amt, 0])]))
 	 else
 		 "0"
 	 end
	end

	def linecd_mh
		if self.line_code == "MH"
			self.int_prem_amt
			# Policy.select(Arel::Nodes::NamedFunction.new('SUM', [Arel::Nodes::NamedFunction.new('DECODE', [:line_cd, 'MH', :prem_amt, 0])]))
		else
			"0"
		end
	end

	def linecd_mn
		if self.line_code == "MN"
			self.int_prem_amt
			# Policy.select(Arel::Nodes::NamedFunction.new('SUM', [Arel::Nodes::NamedFunction.new('DECODE', [:line_cd, 'MN', :prem_amt, 0])]))
		else
			"0"
		end
	end

	def linecd_su
		if self.line_code == "SU"
			self.int_prem_amt
			# Policy.select(Arel::Nodes::NamedFunction.new('SUM', [Arel::Nodes::NamedFunction.new('DECODE', [:line_cd, 'SU', :prem_amt, 0])]))
		else
			"0"
		end
	end

	def linecd_av
		if self.line_code == "AV"
			self.int_prem_amt
			# Policy.select(Arel::Nodes::NamedFunction.new('SUM', [Arel::Nodes::NamedFunction.new('DECODE', [:line_cd, 'AV', :prem_amt, 0])]))
		else
			"0"
		end
	end

end
