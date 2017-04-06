require 'will_paginate'
class MotorsController < ApplicationController
  before_action :set_motor, only: [:show, :edit, :update, :destroy]

  # GET /motors
  # GET /Policy.json
  def index
    start_date = params[:start_date]
    end_date = params[:end_date]
    @motors = Policy.where(acct_ent_date: start_date..end_date).or(Policy.where(spld_acct_ent_date: start_date..end_date)).where(line_code: "MC").includes(:item, :item_peril, :peril, :vehicle, :mc_car_company, :type_of_body).paginate(:page => params[:page], :per_page => 30)
  end

  # GET /motors/1
  # GET /motors/1.json
  def show
  end

  # GET /motors/new
  def new
    @motors = Policy.new
  end

  # GET /motors/1/edit
  def edit
  end

  # POST /motors
  # POST /Policy.json
  def create
    @motors = Policy.new(motor_params)

    respond_to do |format|
      if @Policy.save
        format.html { redirect_to @motors, notice: 'Motor was successfully created.' }
        format.json { render :show, status: :created, location: @motors }
      else
        format.html { render :new }
        format.json { render json: @Policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /motors/1
  # PATCH/PUT /motors/1.json
  def update
    respond_to do |format|
      if @Policy.update(motor_params)
        format.html { redirect_to @motors, notice: 'Motor was successfully updated.' }
        format.json { render :show, status: :ok, location: @motors }
      else
        format.html { render :edit }
        format.json { render json: @Policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /motors/1
  # DELETE /motors/1.json
  def destroy
    @Policy.destroy
    respond_to do |format|
      format.html { redirect_to motors_url, notice: 'motors was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_motor
      @motors = Policy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def motor_params
      params.fetch(:policies, {})
    end
end
