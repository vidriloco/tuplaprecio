# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  include AuthenticatedSystem
  
  def nivel_logged_in(args)
    if logged_in?
      if args.index(Administracion.nivel_de(current_user.rol.nombre)).nil?
        redirect_to :back
      end
      current_user
    else
      redirect_to(new_sesion_path)
    end
  end
  
  # POST /objeto.js
  def create
    modelo_pluralized = @current_controller.split("Controller")[0]
    modelo = modelo_pluralized.singularize
    @objeto = modelo.capitalize.constantize.new(params[modelo.to_sym])

    respond_to do |format|
      if @objeto.save
        format.js do
           render :update do |page|
             page[modelo.pluralize].replace_html :partial => "administraciones/index_modelo_barra", 
                                                   :locals => {:modelo => modelo}
             page[modelo.pluralize].visual_effect :appear
             page << "Nifty('div##{modelo.pluralize}');"
           end
         end
      else
        @errores=@objeto.errors.inject({}) { |h, par| (h[par.first] || h[par.first] = String.new) << "#{par.last}, " ; h }
        format.js do 
          render :update do |page|
            page["errores_#{modelo}"].replace_html :partial => "compartidos/errores_modelo", 
                                                :locals => {:modelo => modelo} 
            page["errores_#{modelo}"].appear                                    
            page["errores_#{modelo}"].visual_effect :highlight, :startcolor => "#AB0B00", :endcolor => "#E6CFD1"
          end
        end
      end
    end
  end
  
  def edit
    modelo_pluralized = @current_controller.split("Controller")[0]
    modelo = modelo_pluralized.singularize
    instance_variable_set("@#{modelo}", modelo.capitalize.constantize.find(params[:id]))
    
    respond_to do |format|
       format.js do
         render :update do |page|
           page[modelo_pluralized].replace_html :partial => "edit_#{modelo}", 
                                              :locals => {:modelo => modelo}
           page[modelo_pluralized].visual_effect :appear
           page << "Nifty('div##{modelo_pluralized}');"
         end
       end
    end
    
  end
  
  # GET /objeto/index.js
  def listing
    modelo_pluralized = @current_controller.split("Controller")[0]
    modelo = modelo_pluralized.singularize
    @objetos = modelo.capitalize.constantize.all
    
    respond_to do |format|
       format.js do
         render :update do |page|
           page[modelo_pluralized].replace_html :partial => "compartidos/listing_modelo", 
                                              :locals => {:modelo => modelo}
           page[modelo_pluralized].visual_effect :appear
           page << "Nifty('div##{modelo_pluralized}');"
         end
       end
    end
  end
  
  def destroy
    modelo_pluralized = @current_controller.split("Controller")[0]
    modelo = modelo_pluralized.singularize
    @objeto = modelo.capitalize.constantize.find(params[:id])
    @objeto.destroy
    
    respond_to do |format|
       format.js do
         render :update do |page|
           if modelo.capitalize.constantize.count == 0
             page[modelo.pluralize].replace_html :partial => "administraciones/index_modelo_barra", 
                                                 :locals => {:modelo => modelo}
             page[modelo.pluralize].visual_effect :appear
             page << "Nifty('div##{modelo.pluralize}');"
           else   
             page["#{modelo}_#{params[:id]}"].visual_effect :fade
           end
         end
       end
    end
    
  end
  
  # GET /objeto/new.js
  def new
    modelo_pluralized = @current_controller.split("Controller")[0]
    modelo = modelo_pluralized.singularize
    instance_variable_set("@#{modelo}", modelo.capitalize.constantize.new)
     respond_to do |format|
       format.js do
         render :update do |page|
           page[modelo_pluralized].replace_html :partial => "new_#{modelo}", 
                                              :locals => {:modelo => modelo}
           page[modelo_pluralized].visual_effect :appear
           page << "Nifty('div##{modelo_pluralized}');"
         end
       end
     end
  end
  
  def update
    modelo_pluralized = @current_controller.split("Controller")[0]
    modelo = modelo_pluralized.singularize
    @objeto = modelo.capitalize.constantize.find(params[:id])

    respond_to do |format|
      format.js do
        if @objeto.update_attributes(params[modelo.to_sym])
          render :update do |page|
            page[modelo.pluralize].replace_html :partial => "administraciones/index_modelo_barra", 
                                                  :locals => {:modelo => modelo}
            page[modelo.pluralize].visual_effect :appear
            page << "Nifty('div##{modelo.pluralize}');"
          end
        else
          @errores=@objeto.errors.inject({}) { |h, par| (h[par.first] || h[par.first] = String.new) << "#{par.last}, "; h }
          
          render :update do |page|
            page["errores_#{modelo}"].replace_html :partial => "compartidos/errores_modelo", 
                                                  :locals => {:modelo => modelo} 
            page["errores_#{modelo}"].appear                                    
            page["errores_#{modelo}"].visual_effect :highlight, :startcolor => "#AB0B00", :endcolor => "#E6CFD1"
          end
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
end
