require 'test_helper'
require 'shared'
class AdministracionesControllerTest < ActionController::TestCase
  include Shared
  
  def setup
    
  end
  
  test "should get index" do
    crea_usuario_relacionado_a "Administracion"
    cambia_controller
    get :index
    assert_response :success
  end

  test "should get new" do
    crea_usuario_relacionado_a "Administracion"
    cambia_controller
    get :new
    assert_response :success
  end

  test "should show administracion" do
    a=crea_usuario_relacionado_a "Administracion"
    cambia_controller
    get :show, :id => a.to_param
    assert_response :success
  end

  test "should get edit" do
    a=crea_usuario_relacionado_a "Administracion"
    cambia_controller
    get :index
    get :edit, :id => a.to_param
    assert_response :success
  end

  test "should update administracion" do
    a=crea_usuario_relacionado_a "Administracion"
    cambia_controller
    put :update, :id => a.to_param, :administracion => { }
    assert_redirected_to administracion_path(a)
  end
  
  test "usuarios de tipo 'Plaza' NO entran a la sección de administracion" do
    crea_usuario_relacionado_a "Plaza", {:nombre => "San Luis Potosí"}
    cambia_controller
    get :index
    assert_redirected_to new_sesion_path
  end
  
  test "usuarios de tipo 'Administracion' entran a la sección de administracion" do
    a=crea_usuario_relacionado_a "Administracion"
    cambia_controller
    get :index
    assert_response :success
  end
  
  test "usuario no existente debe no poder entrar" do
    post :create, :login => 'paquito', :password => 'pagoda'
    get :index
    assert_redirected_to new_sesion_path
  end
  
end
