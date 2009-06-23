require 'test_helper'

class MetaconceptosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:metaconceptos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create metaconcepto" do
    assert_difference('Metaconcepto.count') do
      post :create, :metaconcepto => { }
    end

    assert_redirected_to metaconcepto_path(assigns(:metaconcepto))
  end

  test "should show metaconcepto" do
    get :show, :id => metaconceptos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => metaconceptos(:one).to_param
    assert_response :success
  end

  test "should update metaconcepto" do
    put :update, :id => metaconceptos(:one).to_param, :metaconcepto => { }
    assert_redirected_to metaconcepto_path(assigns(:metaconcepto))
  end

  test "should destroy metaconcepto" do
    assert_difference('Metaconcepto.count', -1) do
      delete :destroy, :id => metaconceptos(:one).to_param
    end

    assert_redirected_to metaconceptos_path
  end
end
