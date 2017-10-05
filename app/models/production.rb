class Production < ApplicationRecord

  self.table_name = "giis_intermediary"
	self.primary_key = "intm_no"

	alias_attribute :name, :intm_name
	alias_attribute :no, :intm_no
  alias_attribute :type, :intm_type
  alias_attribute :iss_source, :iss_cd
  alias_attribute :last, :last_update

	has_many :invoices, foreign_key: :intrmdry_intm_no
	has_many :policies, through: :invoices, foreign_key: :policy_id
  has_one :issource, foreign_key: :iss_cd, primary_key: :iss_cd

  scope :filter_by_date, lambda { | start_date,end_date | left_joins(:policies).merge(Policy.filter_date(start_date,end_date)) }
  scope :order_by_issue_cd, -> { order(  name: :asc, no: :asc, type: :asc) }

  def issue_src(start_date,end_date)
    prod = self.policies.search_date(@start_date, @end_date).each do | policy |
    for intm in prod[policy]
        if intm.iss_cd == self.issource.iss_cd
          self.issource.iss_name
        end
     end
    end
  end

  	def issue_source
      if self.iss_cd == self.issource.iss_cd
        self.issource.iss_name
      end
    end

  # def self.intm_prod_search(intm_prod_search)
  #   if intm_prod_search
  #     # Production.limit(20).includes(:issource, :invoices).order(:iss_source).each do |intermediary|
  #     #   @production = intermediary.policies.search_date(start_date,end_date).page(params[:page])
  #     # @productions = Production.includes(:policies).where('gipi_polbasic' => {acct_ent_date: start_date..end_date}).page(params[:page])
  #     @productions = Production.limit(50).includes(:issource, :invoices).order(:iss_source).page(params[:page])
  #     # end
  #   end
  # end

end
