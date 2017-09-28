class PoliciesController < ApplicationController

  before_action :set_policy, only: [:show, :edit, :update, :destroy]

  # GET /policies
  # GET /policies.json
  def index
    start_date =  (if params[:start_date].nil? then Date.current.beginning_of_month else  params[:start_date] end)
    end_date =  (if params[:end_date].nil? then Date.current.end_of_month else  params[:end_date] end)
    @policies = Policy.pol_search_date(start_date,end_date).paginate(:page => params[:page], :per_page => 30)
    @policies_csv = Policy.pol_search_date(start_date,end_date)

       respond_to do |format|
       format.html
       format.csv { send_data @policies_csv.to_csv1(start_date,end_date), filename: "production-#{start_date} / #{end_date}.csv" }
       format.xls
       format.pdf do
          pdf = PolicyReport1.new(@policies, start_date, end_date)
          send_data pdf.render,filename: "Policies.pdf",
                              type: "application/pdf"
                              # ,
                              # disposition: "inline"
      end
    end
  end

  # GET /policies/1
  # GET /policies/1.json
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
    @policy = Policy.new(policy_params)

    respond_to do |format|
      if @policy.save
        format.html { redirect_to @policy, notice: 'Policy was successfully created.' }
        format.json { render :show, status: :created, location: @policy }
      else
        format.html { render :new }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /policies/1
  # PATCH/PUT /policies/1.json
  def update
    respond_to do |format|
      if @policy.update(policy_params)
        format.html { redirect_to @policy, notice: 'Policy was successfully updated.' }
        format.json { render :show, status: :ok, location: @policy }
      else
        format.html { render :edit }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /policies/1
  # DELETE /policies/1.json
  def destroy
    @policy.destroy
    respond_to do |format|
      format.html { redirect_to policies_url, notice: 'Policy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_policy
      @policy = Policy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def policy_params
      params.fetch(:policy, {})
    end
end
