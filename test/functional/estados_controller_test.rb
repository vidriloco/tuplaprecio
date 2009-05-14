require 'test_helper'

class EstadosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:estados)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create estado" do
    assert_difference('Estado.count') do
      post :create, :estado => { }
    end

    assert_redirected_to estado_path(assigns(:estado))
  end

  test "should show estado" do
    e=Estado.build
    e.save!
    get :show, :id => e.to_param
    assert_response :success
  end

  test "should get edit" do
    e=Estado.build
    e.save!
    get :edit, :id => e.to_param
    assert_response :success
  end

  test "should update estado" do
    e=Estado.build
    e.save!
    put :update, :id => e.to_param, :estado => { }
    assert_redirected_to estado_path(assigns(:estado))
  end

  test "should destroy estado" do
    e=Estado.build
    e.save!
    assert_difference('Estado.count', -1) do
      delete :destroy, :id => e.to_param
    end

    assert_redirected_to estados_path
  end
  
  private
  
    def crea_usuario_relacionado_a(string, args={})
      related_obj=string.constantize.new args 
      u=Usuario.new :login=>"juanelo", :name => "Juan", :password => "pagoda", :password_confirmation => "pagoda", :email => "juanelo@example.com"
      u.save!
      related_obj.agrega_nuevo_usuario u
      related_obj
    end
    
    def cambia_controller
      @controller = SesionesController.new
      post :create, :login => 'juanelo', :password => 'pagoda'
      @controller = AdministracionesController.new
    end
end
