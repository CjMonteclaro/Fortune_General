class TypeOfBody < ApplicationRecord

      	self.table_name = "giis_type_of_body"
      	self.primary_key = "type_of_body_cd"

      	alias_attribute :type_body_code, :type_of_body_cd
      	alias_attribute :body_type, :type_of_body

        belongs_to :vehicle
        belongs_to :policy, through: :vehicle, foreign_key: :policy_id
end
