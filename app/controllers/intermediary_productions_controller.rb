class IntermediaryProductionsController < ApplicationController

  def index
    @start_date =  (if params[:start_date].nil? then Date.current.beginning_of_month else  params[:start_date] end)
    @end_date =  (if params[:end_date].nil? then Date.current.end_of_month else  params[:end_date] end)
    # @productions = Production.distinct.order_by_issue_cd.filter_by_date(@start_date,@end_date).page(params[:page])
    # Policy.distinct.limit(50).filter_date(if @start_date.nil? then Date.current.beginning_of_month else @start_date end,if @end_date.nil? then Date.current.end_of_month else @end_date end).page(params[:page])
    @intermediary_productions = Policy.distinct.limit(50).filter_date(Date.current.beginning_of_month,Date.current.end_of_month).page(params[:page])

    # @intermediary_productions_group = @intermediary_productions.group('giis_intermediary.intm_name','giis_intermediary.intm_no','giis_intermediary.intm_type','giis_issource.iss_name').sum(:pre_amt)
    # @intermediary_productions_values1 = @intermediary_productions_group.values.paginate(:page => params[:value_page], :per_page => 30)
    # @intermediary_productions_values = @intermediary_productions_group.page(params[:page]).per(30)


        respond_to do |format|
         format.html
         format.csv { send_data @intermediary_productions.intm_prod_csv(start_date,end_date), filename: "intermediary_productions #{start_date} / #{end_date}.csv" }
         format.xls
         format.pdf do
            pdf = IntermediaryProductionsReport.new(@intermediary_productions, start_date, end_date)
            send_data pdf.render,filename: "IntermediaryProduction.pdf",
                                type: "application/pdf"
                              # ,
                              # disposition: "inline"
      end
    end
  end

  def show

  end

  # GET /policies/new
  def new
    @policy = Policy.new
  end

  # GET /policies/1/edit
  def edit
  end

  # POST /policies
  # POST /policies.json
  def create
    # @policy = Policy.new(policy_params)
    #
    # respond_to do |format|
    #   if @policy.save
    #     format.html { redirect_to @policy, notice: 'Policy was successfully created.' }
    #     format.json { render :show, status: :created, location: @policy }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @policy.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # def policy_params
  #   params.fetch(:policy, {})
  # end

end
