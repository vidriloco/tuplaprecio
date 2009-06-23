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
    @modelos = ["estado",
               "plaza",
               "metaconcepto", 
               "metaservicio", 
               "metasubservicio",
               "usuario", 
               "rol"]
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # Método de controlador que se encarga de restarurar el partial original de un modelo en la vista :index
  def restaura_modelo_barra
    modelo = params[:modelo]
    respond_to do |format|
      format.js do
        render :update do |page|
          page[modelo.pluralize].replace_html :partial => "index_modelo_barra", :locals => {:modelo => modelo}
          page[modelo.pluralize].visual_effect :appear
          page << "Nifty('div##{modelo.pluralize}');"
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
