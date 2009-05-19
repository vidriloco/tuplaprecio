class AdministracionesController < ApplicationController
  
  before_filter :only => [:asigna_nivel, :index] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 podrán ejecutar la acción definida
    # en "only"
    controller.nivel_logged_in(["nivel 1"])
  end
  
  before_filter :only => [:destroy_tuple, :ver] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1", "nivel 2"])
  end
  
  # GET /administraciones
  # GET /administraciones.xml
  def index
    @administraciones = Administracion.all
    @modelos_independientes = ["estado","plaza","paquete", "concepto", "categoria", "usuario", "rol", "servicio"]
    @modelos_relacionados = ["incorporado", "especializado"]
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @administraciones }
    end
  end

  # DELETE /servicios/1
  # DELETE /servicios/1.xml
  
  def destroy_tuple
    id_number = params[:id].gsub(/\D/,'')
    tipo = params[:tipo].gsub(/\d/,'')
    @object = tipo.constantize.find(id_number)
    @object.destroy
    if tipo.constantize.count.eql? 1
      en_plural=tipo
    else
      en_plural=tipo.pluralize
    end
    respond_to do |format|
      format.js {
        render :update do |page|
          
          page.visual_effect :fade, "#{tipo}#{id_number}", :duration => 2
          # hace un update sobre el div (cuenta...) y más adelante actualiza el despliegue 
          # de la cuenta de registros en administraciones/index.html.erb
          page.replace_html "cuenta#{tipo.capitalize}", "<b>#{tipo.constantize.count}</b>"
          page.replace_html "sustantivo#{tipo.capitalize}", en_plural
        end
      }
    end
    
  end
  
  # Despliega un listado general del estado de cada modelo (excepto administrador)
  def ver
    div_act=params[:div].gsub(/\d/,'')
    # tipo corresponde al modelo del cuál se va a devolver datos
    tipo=params[:tipo].gsub(/\d/,'')
    obj_desp=tipo.capitalize.constantize.paginate :all, :page => params[:page]
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html div_act, :partial => 'compartidos/verModelo', 
                                     :locals => {:obj_desp => obj_desp, :tipo => tipo, :div_act => div_act}
        end
      end
    end
  end
  
  # Asigna uno de los tres niveles de permisos a un rol.
  def asigna_nivel
    nivel, nombre=params[:nivel_y_nombre].split('-')
     msg = "<p>El rol <b>#{nombre.capitalize}</b> tiene ahora nivel <b>#{nivel}</b>"
    admin=Administracion.first
    if nivel == "1"
      admin.nivel_alto = nombre      
    elsif nivel == "2"
      admin.nivel_medio = nombre
    elsif nivel == "3"
      admin.nivel_bajo = nombre
    end
    admin.save!
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "aviso_importante_rol_#{params[:id]}", msg
        end
      end
    end
  end
  
end
