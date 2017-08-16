require 'test_helper'

class TravelpasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @travelpa = travelpas(:one)
  end

  test "should get index" do
    get travelpas_url
    assert_response :success
  end

  test "should get new" do
    get new_travelpa_url
    assert_response :success
  end

  test "should create travelpa" do
    assert_difference('Travelpa.count') do
      post travelpas_url, params: { travelpa: {  } }
    end

    assert_redirected_to travelpa_url(Travelpa.last)
  end

  test "should show travelpa" do
    get travelpa_url(@travelpa)
    assert_response :success
  end

  test "should get edit" do
    get edit_travelpa_url(@travelpa)
    assert_response :success
  end

  test "should update travelpa" do
    patch travelpa_url(@travelpa), params: { travelpa: {  } }
    assert_redirected_to travelpa_url(@travelpa)
  end

  test "should destroy travelpa" do
    assert_difference('Travelpa.count', -1) do
      delete travelpa_url(@travelpa)
    end

    assert_redirected_to travelpas_url
  end
end
