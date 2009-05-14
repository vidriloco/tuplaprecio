require File.dirname(__FILE__) + '/../test_helper'
require 'sesiones_controller'

# Re-raise errors caught by the controller.
class SesionesController; def rescue_action(e) raise e end; end

class SesionesControllerTest < ActionController::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :usuarios

  def test_should_login_and_redirect
    post :create, :login => 'quentin', :password => 'monkey'
    assert session[:usuario_id]
    assert_response :success
  end

  def test_should_fail_login_and_not_redirect
    post :create, :login => 'quentin', :password => 'bad password'
    assert_nil session[:usuario_id]
    assert_response :success
  end

  def test_should_logout
    login_as :quentin
    get :destroy
    assert_nil session[:usuario_id]
    assert_response :redirect
  end

  def test_should_remember_me
    @request.cookies["auth_token"] = nil
    post :create, :login => 'quentin', :password => 'monkey', :remember_me => "1"
    assert_not_nil @response.cookies["auth_token"]
  end

  def test_should_not_remember_me
    @request.cookies["auth_token"] = nil
    post :create, :login => 'quentin', :password => 'monkey', :remember_me => "0"
    puts @response.cookies["auth_token"]
    assert @response.cookies["auth_token"].blank?
  end
  
  def test_should_delete_token_on_logout
    login_as :quentin
    get :destroy
    assert @response.cookies["auth_token"].blank?
  end

  def test_should_login_with_cookie
    usuarios(:quentin).remember_me
    @request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    assert @controller.send(:logged_in?)
  end

  def test_should_fail_expired_cookie_login
    usuarios(:quentin).remember_me
    usuarios(:quentin).update_attribute :remember_token_expires_at, 5.minutes.ago
    @request.cookies["auth_token"] = cookie_for(:quentin)
    get :new
    assert !@controller.send(:logged_in?)
  end

  def test_should_fail_cookie_login
    usuarios(:quentin).remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    assert !@controller.send(:logged_in?)
  end
  
  def test_should_redirect_to_admin_when_user_create_is_admin
    usuario, admin = crea_usuario_relacionado_a "Administracion"
    post :create, :login => 'juanelo', :password => 'pagoda'
    assert_redirected_to administraciones_path
  end
  
  def test_should_redirect_to_plaza_when_user_create_is_plaza
    usuario, admin = crea_usuario_relacionado_a "Plaza", :nombre => "Qro"
    post :create, :login => 'juanelo', :password => 'pagoda'
    assert_redirected_to plazas_path
  end
  
  def test_should_redirect_to_sesion_new_when_user_not_asigned
    usuario=Usuario.new :login=>"juanelo", :name => "Juan", :password => "pagoda", :password_confirmation => "pagoda", :email => "juanelo@example.com"
    post :create, :login => 'juanelo', :password => 'pagoda'
    assert_response :success
  end

  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(usuario)
      auth_token usuarios(usuario).remember_token
    end
    
    def crea_usuario_relacionado_a(string, args={})
      related_obj=string.constantize.new args 
      usuario=Usuario.new :login=>"juanelo", :name => "Juan", :password => "pagoda", :password_confirmation => "pagoda", :email => "juanelo@example.com"
      usuario.save!
      related_obj.agrega_nuevo_usuario usuario
      return usuario,related_obj
    end
end
