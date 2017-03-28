require 'test_helper'

class MotorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @motor = motors(:one)
  end

  test "should get index" do
    get motors_url
    assert_response :success
  end

  test "should get new" do
    get new_motor_url
    assert_response :success
  end

  test "should create motor" do
    assert_difference('Motor.count') do
      post motors_url, params: { motor: {  } }
    end

    assert_redirected_to motor_url(Motor.last)
  end

  test "should show motor" do
    get motor_url(@motor)
    assert_response :success
  end

  test "should get edit" do
    get edit_motor_url(@motor)
    assert_response :success
  end

  test "should update motor" do
    patch motor_url(@motor), params: { motor: {  } }
    assert_redirected_to motor_url(@motor)
  end

  test "should destroy motor" do
    assert_difference('Motor.count', -1) do
      delete motor_url(@motor)
    end

    assert_redirected_to motors_url
  end
end
