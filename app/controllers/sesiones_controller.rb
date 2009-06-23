# This controller handles the login/logout function of the site.  
class SesionesController < ApplicationController

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    user = Usuario.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      rol = user.rol
      nivel_usuario=Administracion.nivel_de(rol.nombre)
      if nivel_usuario.eql? "nivel 1"
          redirect_to administraciones_path
      elsif nivel_usuario.eql?("nivel 2") 
          redirect_to tablero_nivel_dos_path
      elsif nivel_usuario.eql?("nivel 3")
          redirect_to tablero_nivel_tres_path
      else
          render :action => 'new'
      end
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
