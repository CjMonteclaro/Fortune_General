class McCarCompany < ApplicationRecord

    	self.table_name = "giis_mc_car_company"
    	self.primary_key = "car_company_cd"

    	alias_attribute :car_comp_code, :car_company_cd
    	alias_attribute :car_comp, :car_company

      belongs_to :vehicle, foreign_key: :car_comp_code
      belongs_to :policy
end
