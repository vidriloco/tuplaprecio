require 'test_helper'

class ServiciosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:servicios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create servicio" do
    assert_difference('Servicio.count') do
      post :create, :servicio => { }
    end

    assert_redirected_to servicio_path(assigns(:servicio))
  end

  test "should show servicio" do
    s = Servicio.build
    s.save!
    get :show, :id => s.to_param
    assert_response :success
  end

  test "should get edit" do
    s = Servicio.build
    s.save!
    get :edit, :id => s.to_param
    assert_response :success
  end

  test "should update servicio" do
    s = Servicio.build
    s.save!
    put :update, :id => s.to_param, :servicio => { }
    assert_redirected_to servicio_path(assigns(:servicio))
  end

  test "should destroy servicio" do
    s = Servicio.build
    s.save!
    assert_difference('Servicio.count', -1) do
      delete :destroy, :id => s.to_param
    end

    assert_redirected_to servicios_path
  end
end
