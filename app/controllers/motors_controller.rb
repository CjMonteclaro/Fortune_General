class MotorsController < ApplicationController
  before_action :set_motor, only: [:show, :edit, :update, :destroy]

  # GET /motors
  # GET /Motorpolicy.json
  def index
    detect_date_params
    @pol_no = params[:policy_no]

    @motor_policies = Motorpolicy.motors_search(@start_date, @end_date).page(params[:page])
  #  @claims = Claim.claim_search(@start_date, @end_date, params[:page])

    respond_to do |format|
    format.html
    format.csv { send_data Motorpolicy.motor_to_csv(@start_date,@end_date), filename: "motorcar-#{@start_date} "/" #{@end_date}.csv" }
    format.xls
    format.pdf do
       pdf = MotorsReport.new(Motorpolicy, @start_date, @end_date)
       send_data pdf.render,filename: "MotorCar.pdf",
                           type: "application/pdf"
                           # ,
                           # disposition: "inline"
     end
   end
  end

  def index2
    detect_date_params
    @pol_no = params[:policy_no]
    @motor_policies = Motorpolicy.motor_search(@start_date, @end_date).page(params[:page])
    # @motor_policies = Motorpolicy.where(line_code: "MC").order('policy_id DESC').limit(5).includes(:item, :item_perils, :perils, :vehicle, :mc_car_company, :type_of_body).page(params[:page])
    respond_to do |format|
      format.html
    end
  end

  def motor_search
    detect_date_params
    @pol_no = params[:policy_no]
    @motor_policies = Motorpolicy.motor_search(@start_date, @end_date).page(params[:page])
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

    def detect_date_params
      if params[:start_date].present?
        @start_date = params[:start_date]
        @end_date =  params[:end_date]
      else
        @start_date =  Date.current.beginning_of_month
        @end_date =  Date.current.end_of_month
      end
    end

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
