class MotorsController < ApplicationController
  before_action :set_motor, only: [:show, :edit, :update, :destroy]

  # GET /motors
  # GET /Motorpolicy.json
  def index
    @start_date =  (if params[:start_date].nil? then Date.current.beginning_of_month else  params[:start_date] end)
    @end_date =  (if params[:end_date].nil? then Date.current.end_of_month else  params[:end_date] end)
    @pol_no = params[:policy_no]

    @motor_policies = Motorpolicy.motor_search(@start_date, @end_date).page(params[:page])
  #  @claims = Claim.claim_search(@start_date, @end_date, params[:page])
    @motor_policies_csv = Motorpolicy.motor_search(@start_date, @end_date)

    respond_to do |format|
    format.html
    format.csv { send_data @motor_policies_csv.to_csv1(@start_date,@end_date), filename: "motorcar-#{@start_date} "/" #{@end_date}.csv" }
    format.xls
    format.pdf do
       pdf = MotorsReport.new(@motor_policies_csv, @start_date, @end_date)
       send_data pdf.render,filename: "MotorCar.pdf",
                           type: "application/pdf"
                           # ,
                           # disposition: "inline"
     end
   end
  end

  def index2
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @pol_no = params[:policy_no]

    @motor_policies = Motorpolicy.motor_search(@start_date, @end_date).page(params[:page])
    # @motor_policies = Motorpolicy.where(line_code: "MC").order('policy_id DESC').limit(5).includes(:item, :item_perils, :perils, :vehicle, :mc_car_company, :type_of_body).page(params[:page])
  end

  # GET /motors/1
  # GET /motors/1.json
  def show
    @motors = Claim.where(claim_no: @pol_no)
  end

  # GET /motors/new
  def new
    @motors = Motorpolicy.new
  end

  # GET /motors/1/edit
  def edit
  end

  # POST /motors
  # POST /Motorpolicy.json
  def create
    @motors = Motorpolicy.new(motor_params)

    respond_to do |format|
      if @Motorpolicy.save
        format.html { redirect_to @motors, notice: 'Motor was successfully created.' }
        format.json { render :show, status: :created, location: @motors }
      else
        format.html { render :new }
        format.json { render json: @Motorpolicy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /motors/1
  # PATCH/PUT /motors/1.json
  def update
    respond_to do |format|
      if @Motorpolicy.update(motor_params)
        format.html { redirect_to @motors, notice: 'Motor was successfully updated.' }
        format.json { render :show, status: :ok, location: @motors }
      else
        format.html { render :edit }
        format.json { render json: @Motorpolicy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /motors/1
  # DELETE /motors/1.json
  def destroy
    @Motorpolicy.destroy
    respond_to do |format|
      format.html { redirect_to motors_url, notice: 'motors was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_motor
      @motors = Claim.where("claim_no like '%?%'", @pol_no)
      # @motors = Motorpolicy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def motor_params
      params.fetch(:policies, {})
    end
end
