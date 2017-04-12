class TypeOfBody < ApplicationRecord

      	self.table_name = "giis_type_of_body"
      	self.primary_key = "type_of_body_cd"

      	alias_attribute :type_body_code, :type_of_body_cd
      	alias_attribute :body_type, :type_of_body

        belongs_to :vehicle, foreign_key: :type_body_code
        belongs_to :policy
end
