class Intermediary < ApplicationRecord
	self.table_name = "giis_intermediary"
	self.primary_key = "intm_no"
	self.sequence_name = 'INTERMEDIARY_INTM_NO_S'

	alias_attribute :name, :intm_name
	alias_attribute :no, :intm_no
	alias_attribute :nickn, :nickname
	alias_attribute :email, :email_add
	alias_attribute :cell_no, :cp_no
	alias_attribute :phon_no, :phone_no
	alias_attribute :faxno, :fax_no
	alias_attribute :homeadd, :home_add
	alias_attribute :bday, :birthdate
	alias_attribute :address, :mail_addr1
	alias_attribute :tin_no, :tin
	alias_attribute :bill_add, :bill_addr1
	alias_attribute :contact_person, :contact_pers
	alias_attribute :int_type_desc, :intm_type
	alias_attribute :issuing_office, :cpi_branch_cd
	alias_attribute :effi_date, :eff_date
	alias_attribute :exp_date, :expiry_date
	alias_attribute :license_no, :lic_tag
	alias_attribute :stat, :active_tag
	alias_attribute :rem, :remarks

	alias_attribute :parnt_intm_no, :parent_intm_no
	alias_attribute :iss_source, :iss_cd
	alias_attribute :cointm_type, :co_intm_type
	alias_attribute :corp, :corp_tag
	alias_attribute :wtaxrate, :wtax_rate
	alias_attribute :invat_rate, :input_vat_rate
	alias_attribute :paymnt, :payt_terms
	alias_attribute :parnt_intm_tin_sw, :prnt_intm_tin_sw
	alias_attribute :spec_rate, :special_rate

		has_many :invoices, foreign_key: :intrmdry_intm_no
		has_many :policies, through: :invoices, foreign_key: :policy_id


		def self.search(search)
				if search
					where('intm_no = ?', "#{search}")
				else
					order('intm_no')
				end
			end

	def self.to_csv(stats)

		# if stats == "A"
			attributes = %w{intm_no p_intm_no intm_name Nname email cell phone fax home_add bday address iss_source tin p_tin wtax_rate input_vat_rate spec_rate payment bill_add contact_person intm_type co_intm_type iss_office corporate eff_date exp_date license status remarks}
      CSV.generate(headers: true) do |csv|
        csv << attributes
        Intermediary.all.order(:stat).each do |intermediary|
        csv << [intermediary.no, intermediary.parnt_intm_no,intermediary.name,intermediary.nickn,intermediary.email,intermediary.cell_no,intermediary.phon_no,intermediary.faxno,intermediary.homeadd,intermediary.bday,intermediary.address,intermediary.iss_source, intermediary.tin_no, intermediary.parnt_intm_tin_sw, intermediary.wtaxrate,	intermediary.invat_rate, intermediary.spec_rate, intermediary.paymnt, intermediary.bill_add, intermediary.contact_person,	intermediary.int_type_desc,	intermediary.cointm_type, intermediary.issuing_office, intermediary.corp,	intermediary.effi_date,	intermediary.exp_date, intermediary.license_no, intermediary.show_status, intermediary.rem ]
				end
      end
		
	end

 	 def set_intm_no
	  last_intm_no = Intermediary.maximum(:no)
	  self.no = last_intm_no.to_i + 1
	 end

	def show_status
		if stat == "A"
			"A"
		else
			"I"
		end
	end

end
