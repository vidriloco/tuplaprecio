# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout 'application_layout'
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  
  def nivel_logged_in(args)
    redirect_to(new_sesion_path) if session[:usuario_id].nil?
    
    usuario=Usuario.find(session[:usuario_id])      
    admin=Administracion.first
    
    if args.index(admin.nivel_de(usuario.rol.nombre)).nil?
      redirect_to :back
    end
  end
  
  
  private 
    before_filter :instantiate_controller_and_action_names
    
    def instantiate_controller_and_action_names
      @current_action = action_name
      @current_controller = controller_name
    end
    
    def admin_logged_in
      unless Usuario.es_tipo(session[:usuario_id], "administracion")
        redirect_to new_sesion_path
      end
    end
    
    def only_if_these_are_logged_in()
      unless Usuario.es_tipo(session[:usuario_id], "plaza") || Usuario.es_tipo(session[:usuario_id], "administracion")
        redirect_to new_sesion_path
      end
    end
  
    def recibir_parametros_comunes
      ds=params[:datos_separacion]
      return ds[:id_supermodelo], ds[:submodelo], ds[:id_submodelo], params[:identificador]
    end
end
