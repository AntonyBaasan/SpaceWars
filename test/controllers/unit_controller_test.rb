require 'test_helper'

class UnitControllerTest < ActionController::TestCase
  test "should get name:string" do
    get :name:string
    assert_response :success
  end

  test "should get type:integer" do
    get :type:integer
    assert_response :success
  end

  test "should get attack:integer" do
    get :attack:integer
    assert_response :success
  end

  test "should get defence:integer" do
    get :defence:integer
    assert_response :success
  end

end
