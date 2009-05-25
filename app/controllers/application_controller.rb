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
    
    if args.index(Administracion.nivel_de(usuario.rol.nombre)).nil?
      redirect_to :back
    end
  end
  
  def objetos_a_sesion
     sesion_objeto = params[:sesion].to_sym
     if eval(params[:seleccion])
       session[sesion_objeto].delete(params[:id].to_i)
     else
       if session[sesion_objeto].index(params[:id].to_i).nil?
         session[sesion_objeto] << params[:id].to_i
       end
     end
     render :nothing => :true
  end
  
  # Responde aplicando toggle al div que llega en params[:div_id]
  def esconde_div
    div=params[:div_id]
    respond_to do |format|
      format.js do
        render :update do |page|
          page.toggle(div)
        end
      end
    end
  end
  
  private 
    before_filter :instantiate_controller_and_action_names
    
    def instantiate_controller_and_action_names
      @current_action = action_name
      @current_controller = controller_name
    end
    
    def admin_logged_in?
      @usuario = Usuario.find(session[:usuario_id])
      return true if Administracion.nivel_de(@usuario.rol.nombre).eql?("nivel 1")
    end
  
    def recibir_parametros_comunes
      ds=params[:datos_separacion]
      return ds[:id_supermodelo], ds[:submodelo], ds[:id_submodelo], params[:identificador]
    end
end
