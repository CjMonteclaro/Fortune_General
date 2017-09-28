class MotorDecsController < ApplicationController
  before_action :set_motor_dec, only: [:show, :edit, :update, :destroy]

  # GET /motor_decs
  # GET /motor_decs.json
  def index
    @motor_decs = MotorDec.where(line_code: 'MC', effective_date: "2017-06-01".to_datetime..."2017-06-30".to_datetime).order(:issue_source, :sequence_no).includes(:assured, {:vehicle => [:mc_car_company, :type_of_body]})
  end
