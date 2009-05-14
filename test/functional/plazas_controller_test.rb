require 'test_helper'

class PlazasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plazas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create plaza" do
    assert_difference('Plaza.count') do
      post :create, :plaza => { :nombre => "QRO"}
    end

    assert_redirected_to plaza_path(assigns(:plaza))
  end

  test "should show plaza" do
    p = Plaza.build
    p.save!
    get :show, :id => p.to_param
    assert_response :success
  end

  test "should get edit" do
    p = Plaza.build
    p.save!
    get :edit, :id => p.to_param
    assert_response :success
  end

  test "should update plaza" do
    p = Plaza.build
    p.save!
    put :update, :id => p.to_param, :plaza => { }
    assert_redirected_to plaza_path(assigns(:plaza))
  end

  test "should destroy plaza" do
    p = Plaza.build
    p.save!
    assert_difference('Plaza.count', -1) do
      delete :destroy, :id => p.to_param
    end

    assert_redirected_to plazas_path
  end
end
