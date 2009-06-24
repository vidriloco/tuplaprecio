class UsuariosController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  
  before_filter do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1"])
  end

  # render new.rhtml
  def new
    super
  end
  
  def some
    tipo = params[:tipo]
    instance_variable_set "@#{tipo.downcase}", tipo.constantize.find(params[:id])
    @usuarios = eval("Usuario.paginate_by_#{tipo.downcase}_id @#{tipo.downcase}.id, :page => params[:page]")

    respond_to do |format|
      format.html { render 'index.html.erb' }
    end
  end
 
  def create
    #logout_keeping_session!
    @user = Usuario.new(params[:usuario])

    success = @user && @user.save
    respond_to do |format|
      format.js do
        if success && @user.errors.empty?
          render :update do |page|
              page["usuarios"].replace_html :partial => "administraciones/index_modelo_barra", 
                                                     :locals => {:modelo => "usuario"}
              page["usuarios"].visual_effect :appear
              page << "Nifty('div#usuarios');"
              # Protects against session fixation attacks, causes request forgery
              # protection if visitor resubmits an earlier form using back
              # button. Uncomment if you understand the tradeoffs.
              # reset session
              #self.current_usuario = @usuario # !! now logged in

              #flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
          end
        else
          @errores=@user.errors.inject({}) { |h, par| (h[par.first] || h[par.first] = String.new) << "#{par.last}, " ; h }
          render :update do |page|
            page["errores_usuario"].replace_html :partial => "compartidos/errores_modelo", 
                                                :locals => {:modelo => "usuario"} 
            page["errores_usuario"].appear                                    
            page["errores_usuario"].visual_effect :highlight, :startcolor => "#AB0B00", :endcolor => "#E6CFD1"
          end
        end
      end
    end
  end
  
  def separar_objetos
    id_super, submodelo, id_sub, identificador = recibir_parametros_comunes
    
    @subM=submodelo.capitalize.constantize.find(id_sub)
    @usuario=Usuario.find(id_super)
    if submodelo.eql? "Plaza"
      eval("@usuario.responsabilidad=nil")
      @usuario.save!
    elsif submodelo.eql? "Rol"
      @usuario.rol=nil
      @usuario.save!
    end
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html identificador, ""
        end
      end
    end
  end

end
