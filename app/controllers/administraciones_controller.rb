require 'utilidades'
class AdministracionesController < ApplicationController
  
  before_filter :only => [:index, :salida_csv, :salida_rb, :entrada_rb, :limpia_bd] do |controller|
    controller.usuario_es?(:administrador)
  end
  
  before_filter :only => [:restaura_modelo_barra] do |controller|
    controller.usuario_es?(:administrador, :encargado)
  end
  
  before_filter :exporta_usuario_actual, :only => [:entrada_rb, :limpia_bd]
  
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
        if current_user.es_administrador?
          render :update do |page|
            page[modelo.pluralize].replace_html :partial => "index_modelo_barra", :locals => {:modelo => modelo}
            page[modelo.pluralize].visual_effect :appear
            page << "Nifty('div##{modelo.pluralize}');"
          end
        elsif current_user.es_encargado?
          render :update do |page|
            page[modelo.pluralize].replace_html :partial => "tableros/index_modelo_barra", :locals => {:modelo => modelo}
            page[modelo.pluralize].visual_effect :appear
            page << "Nifty('div##{modelo.pluralize}');"
          end
        end
      end
    end
  end
  
  # Acción que se encarga de generar un archivo delimitado por comas
  def salida_csv
    nombre="backup_bd_en_csv"
    path = Utilidades.genera_zip(nombre)
    send_file path, :type => 'application/zip', :disposition => 'attachment', :filename => "#{nombre}.zip"
  end
  
  # Acción que se encarga de generar un archivo en código ruby con los objetos contenidos en la base de datos
  def salida_rb
    path = Utilidades.migracion_exporta_rb
    send_file path, :disposition => 'attachment', :filename => "copia_de_seguridad_#{DateTime.now.to_s(:short)}.rb"
  end
  
  # Acción que se encargado de recibir un archivo en código ruby con definición de objetos para integrarlo a la base de datos
  def entrada_rb
    @modelos = MODELOS
    archivo=params[:zipo]
    if Utilidades.migracion_importa_rb(archivo)
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
    else
      responds_to_parent do
        respond_to do |format|
          format.js do
            render :update do |page|
              page["a_4"].hide
              page["a_5"].visual_effect :appear
            end
          end
        end
      end
    end

  end
  
  # Acción destructiva sobre la base de datos
  def limpia_bd
    Utilidades.limpia_bd(current_user)
    @modelos = MODELOS
  
    render :partial => "modelo_barras"
  end
  
  private
    def exporta_usuario_actual
      Thread.current['usuario'] = current_user.id
    end
  
end
