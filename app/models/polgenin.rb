class Polgenin < ApplicationRecord


	self.table_name = "gipi_polgenin"
	self.primary_key = "policy_id"

	alias_attribute :polgenin_pol_id, :policy_id
	alias_attribute :polgenin_gen_info, :gen_info
	alias_attribute :polgenin_gen_info1, :gen_info01
	alias_attribute :polgenin_initial_info, :initial_info01

	belongs_to :policy, foreign_key: :policy_id

	def travel_class
		/schengen|worldwide|asian/i.match(polgenin_gen_info1).to_s
	end

	def coverage
		case travel_class
			when "SCHENGEN","schengen"
				then "50,000"
			when "WORLWIDE","worldwide"
				then "50,000"
			when "ASIAN","asian"
				then "50,000"
			else "Not Specified"
		end
	end

end
