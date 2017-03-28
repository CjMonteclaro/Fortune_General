class MotorsController < ApplicationController
  before_action :set_motor, only: [:show, :edit, :update, :destroy]

  # GET /motors
  # GET /motors.json
  def index
    @motors = Motor.all
  end

  # GET /motors/1
  # GET /motors/1.json
  def show
  end

  # GET /motors/new
  def new
    @motor = Motor.new
  end

  # GET /motors/1/edit
  def edit
  end

  # POST /motors
  # POST /motors.json
  def create
    @motor = Motor.new(motor_params)

    respond_to do |format|
      if @motor.save
        format.html { redirect_to @motor, notice: 'Motor was successfully created.' }
        format.json { render :show, status: :created, location: @motor }
      else
        format.html { render :new }
        format.json { render json: @motor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /motors/1
  # PATCH/PUT /motors/1.json
  def update
    respond_to do |format|
      if @motor.update(motor_params)
        format.html { redirect_to @motor, notice: 'Motor was successfully updated.' }
        format.json { render :show, status: :ok, location: @motor }
      else
        format.html { render :edit }
        format.json { render json: @motor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /motors/1
  # DELETE /motors/1.json
  def destroy
    @motor.destroy
    respond_to do |format|
      format.html { redirect_to motors_url, notice: 'Motor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_motor
      @motor = Motor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def motor_params
      params.fetch(:motor, {})
    end
end
