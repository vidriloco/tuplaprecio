require 'test_helper'

class PresentacionesControllerTest < ActionController::TestCase
  
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:presentaciones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create presentacion" do
    assert_difference('Presentacion.count') do
      post :create, :presentacion => { }
    end

    assert_redirected_to presentacion_path(assigns(:presentacion))
  end

  test "should show presentacion" do
    p = Presentacion.build
    p.save
    get :show, :id => p.to_param
    assert_response :success
  end

  test "should get edit" do
    p = Presentacion.build
    p.save
    get :edit, :id => p.to_param
    assert_response :success
  end

  test "should update presentacion" do
    p = Presentacion.build
    p.save
    put :update, :id => p.to_param, :presentacion => { }
    assert_redirected_to presentacion_path(assigns(:presentacion))
  end

  test "should destroy presentacion" do
    p = Presentacion.build
    p.save
    assert_difference('Presentacion.count', -1) do
      delete :destroy, :id => p.to_param
    end

    assert_redirected_to presentaciones_path
  end
end
