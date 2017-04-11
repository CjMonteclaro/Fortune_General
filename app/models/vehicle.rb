class Vehicle < ApplicationRecord

  	self.table_name = "gipi_vehicle"
  	self.primary_key = "policy_id"

  	alias_attribute :pol_id, :policy_id
  	alias_attribute :item_number, :item_no
    alias_attribute :modelyear, :model_year
    alias_attribute :mak, :make
    alias_attribute :car_comp_code, :car_company_cd
    alias_attribute :type_body_code, :type_of_body_cd

    belongs_to :item, foreign_key: :item_no

    belongs_to :policy, foreign_key: :policy_id
    has_one :type_of_body, foreign_key: :type_body_code

    has_one :mc_car_company, foreign_key: :car_comp_code

def vehicle_name
"#{self.modelyear}#{self.mc_car_company.car_comp}#{self.make}#{self.type_of_body.body_type}"
end

end
