class IntermediaryProductionsController < ApplicationController

  def index
    start_date = params[:start_date]
    end_date = params[:end_date]

     @intermediary_productions = Policy.where(acct_ent_date: start_date..end_date).or(Policy.where(spld_acct_ent_date: start_date..end_date)).includes(:lines, :issource, :invoice, :intermediary).joins(:lines,:issource,:invoice,:intermediary).order('giis_intermediary.intm_name','giis_issource.iss_name').group('giis_intermediary.intm_name','giis_intermediary.intm_no','giis_intermediary.intm_type','giis_issource.iss_name').sum(:pre_amt)
    #  .paginate(:page => params[:page], :per_page => 30)
    #  .group('giis_intermediary.intm_name','giis_intermediary.intm_no','giis_intermediary.intm_type','giis_issource.iss_name').sum(:pre_amt)

      @intermediary_productions_view = Policy.where(acct_ent_date: start_date..end_date).or(Policy.where(spld_acct_ent_date: start_date..end_date)).includes(:lines,:issource,:invoice,:intermediary).joins(:lines,:issource,:invoice,:intermediary).order('giis_intermediary.intm_name','giis_issource.iss_name')

    #  @intermediary_productions_pa = @intermediary_productions.to_a + @intermediary_productions_view.to_a

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
