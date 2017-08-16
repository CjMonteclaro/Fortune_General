class Vehicle < ApplicationRecord

  	self.table_name = "gipi_vehicle"
  	self.primary_key = "policy_id"

  	alias_attribute :pol_id, :policy_id
  	alias_attribute :item_number, :item_no
    alias_attribute :modelyear, :model_year
    alias_attribute :mak, :make
    alias_attribute :car_comp_code, :car_company_cd
    alias_attribute :type_body_code, :type_of_body_cd

    has_one :item, foreign_key: :policy_id, primary_key: :policy_id

    has_one :policy, foreign_key: :policy_id
    has_one :motorpolicy, foreign_key: :policy_id
    belongs_to :type_of_body, foreign_key: :type_of_body_cd
    belongs_to :mc_car_company, foreign_key: :car_company_cd

  def vehicle_name
      "#{self.modelyear}  #{self.mc_car_company&.car_comp}  #{self.make} #{self.type_of_body&.body_type}"


  end

end
