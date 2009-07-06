require 'utilidades'
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
  
  MODELOS= ["estado", "plaza", "metaconcepto", "metaservicio", "metasubservicio", "zona", "usuario"]
  
  # GET /administraciones
  # GET /administraciones.xml
  def index
    @modelos = MODELOS
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
  
  def salida_csv
    nombre="backup_bd_en_csv"
    path = Utilidades.genera_zip(nombre)
    send_file path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{nombre}.zip"
  end
  
  def salida_rb
    path = Utilidades.migracion_exporta_rb
    send_file path, :disposition => 'attachment', :filename => "copia_de_seguridad_#{DateTime.now.to_s(:short)}.rb"
  end
  
  def entrada_rb
    @modelos = MODELOS
    archivo=params[:zipo]
    Utilidades.migracion_importa_rb(archivo)
    responds_to_parent do
      respond_to do |format|
        format.js do
          render :update do |page|
            page["modelo_barras_admin"].replace_html :partial => "modelo_barras"
            page << "Nifty('div.mensaje_barra');"
            page["a_4"].hide
            page["a_3"].visual_effect :appear
          end
        end
      end
    end
  end
  
  def limpia_bd
    @modelos = MODELOS
    @modelos.each do |modelo|
      if modelo.eql? "usuario"
        modelo.capitalize.constantize.limpia_todos_excepto(current_user)
      elsif modelo.eql? "rol"
        modelo.capitalize.constantize.limpia_todos_excepto(current_user.rol)        
      else
        modelo.capitalize.constantize.destroy_all
      end
    end    
      
    render :partial => "modelo_barras"
  end
  
end
