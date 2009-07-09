class UsuariosController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
    
  before_filter :only => [:edit_by_user, :update] do |controller|
    controller.usuario_es?(:administrador, :encargado)
  end
  
  before_filter :only => [:new, :create, :edit, :destroy, :rol_a_estado, :estado_a_plaza] do |controller|
    controller.usuario_es?(:administrador)
  end

  # render new.rhtml
  def new
    @roles = Rol.all
    @estados = Estado.all
    super
  end
  
  def edit
    @roles = Rol.all
    @estados = Estado.all
    @plazas = Plaza.all
    super
  end
  
  def edit_by_user
    
  end
 
  def create
    #logout_keeping_session!
    @user = Usuario.new(params[:usuario])

    success = @user && @user.guarda(current_user.es_administrador?)
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
  
  def rol_a_estado
    rol = Rol.find params[:rol_id].gsub(/\D/,'')
    estados = Estado.all
    
    respond_to do |format|
      format.js do
        if rol.nombre.eql? "Encargado"
          render :update do |page|
            page['usuario_estado_form'].replace_html :partial => "usuario_estado_form" , :locals => {:estados => estados}
            page['usuario_estado_form'].visual_effect :appear
          end
        else
          render :update do |page|
            page['usuario_estado_form'].visual_effect :fade
          end
        end
      end
    end
  end
  
  def estado_a_plaza
    estado = Estado.find params[:estado_id].gsub(/\D/,'')
    plazas = estado.plazas
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page['usuario_plaza_form'].replace_html :partial => "usuario_plaza_form" , :locals => {:plazas => plazas}
          page['usuario_plaza_form'].visual_effect :appear
        end
      end
    end
  end

end
