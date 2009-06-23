require 'test_helper'

class PaquetesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paquetes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create paquete" do
    assert_difference('Paquete.count') do
      post :create, :paquete => { }
    end

    assert_redirected_to paquete_path(assigns(:paquete))
  end

  test "should show paquete" do
    get :show, :id => paquetes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => paquetes(:one).to_param
    assert_response :success
  end

  test "should update paquete" do
    put :update, :id => paquetes(:one).to_param, :paquete => { }
    assert_redirected_to paquete_path(assigns(:paquete))
  end

  test "should destroy paquete" do
    assert_difference('Paquete.count', -1) do
      delete :destroy, :id => paquetes(:one).to_param
    end

    assert_redirected_to paquetes_path
  end
end
