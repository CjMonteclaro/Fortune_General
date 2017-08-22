class MotorDecsController < ApplicationController
  before_action :set_motor_dec, only: [:show, :edit, :update, :destroy]

  # GET /motor_decs
  # GET /motor_decs.json
  def index
    @motor_decs = MotorDec.where(line_code: 'MC', effective_date: "2017-06-01".to_datetime..."2017-06-30".to_datetime).order(:issue_source, :sequence_no).includes(:assured, {:vehicle => [:mc_car_company, :type_of_body]})
  end

  # GET /motor_decs/1
  # GET /motor_decs/1.json
  def show
  end

  # GET /motor_decs/new
  def new
    @motor_dec = MotorDec.new
  end

  # GET /motor_decs/1/edit
  def edit
  end

  # POST /motor_decs
  # POST /motor_decs.json
  def create
    @motor_dec = MotorDec.new(motor_dec_params)

    respond_to do |format|
      if @motor_dec.save
        format.html { redirect_to @motor_dec, notice: 'Motor dec was successfully created.' }
        format.json { render :show, status: :created, location: @motor_dec }
      else
        format.html { render :new }
        format.json { render json: @motor_dec.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /motor_decs/1
  # PATCH/PUT /motor_decs/1.json
  def update
    respond_to do |format|
      if @motor_dec.update(motor_dec_params)
        format.html { redirect_to @motor_dec, notice: 'Motor dec was successfully updated.' }
        format.json { render :show, status: :ok, location: @motor_dec }
      else
        format.html { render :edit }
        format.json { render json: @motor_dec.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /motor_decs/1
  # DELETE /motor_decs/1.json
  def destroy
    @motor_dec.destroy
    respond_to do |format|
      format.html { redirect_to motor_decs_url, notice: 'Motor dec was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_motor_dec
      @motor_dec = MotorDec.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def motor_dec_params
      params.require(:motor_dec).permit(:insured, :policy_no, :plate_no, :vehicle, :color, :chassis_no, :motor_no, :inception, :expiry)
    end
end
