require 'test_helper'

class MotorDecsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @motor_dec = motor_decs(:one)
  end

  test "should get index" do
    get motor_decs_url
    assert_response :success
  end

  test "should get new" do
    get new_motor_dec_url
    assert_response :success
  end

  test "should create motor_dec" do
    assert_difference('MotorDec.count') do
      post motor_decs_url, params: { motor_dec: { chassis_no: @motor_dec.chassis_no, color: @motor_dec.color, expiry: @motor_dec.expiry, inception: @motor_dec.inception, insured: @motor_dec.insured, motor_no: @motor_dec.motor_no, plate_no: @motor_dec.plate_no, policy_no: @motor_dec.policy_no, vehicle: @motor_dec.vehicle } }
    end

    assert_redirected_to motor_dec_url(MotorDec.last)
  end

  test "should show motor_dec" do
    get motor_dec_url(@motor_dec)
    assert_response :success
  end

  test "should get edit" do
    get edit_motor_dec_url(@motor_dec)
    assert_response :success
  end

  test "should update motor_dec" do
    patch motor_dec_url(@motor_dec), params: { motor_dec: { chassis_no: @motor_dec.chassis_no, color: @motor_dec.color, expiry: @motor_dec.expiry, inception: @motor_dec.inception, insured: @motor_dec.insured, motor_no: @motor_dec.motor_no, plate_no: @motor_dec.plate_no, policy_no: @motor_dec.policy_no, vehicle: @motor_dec.vehicle } }
    assert_redirected_to motor_dec_url(@motor_dec)
  end

  test "should destroy motor_dec" do
    assert_difference('MotorDec.count', -1) do
      delete motor_dec_url(@motor_dec)
    end

    assert_redirected_to motor_decs_url
  end
end
