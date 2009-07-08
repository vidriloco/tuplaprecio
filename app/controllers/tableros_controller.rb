class TablerosController < ApplicationController
  
  before_filter :except => [:index_nivel_dos] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.usuario_es?(:agente)
  end
  
  before_filter :only => [:index_nivel_dos] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.usuario_es?(:encargado)
  end
  
  
  def index_nivel_tres
    @usuario = current_user
    @estados = Estado.all
    respond_to do |format|
      format.html
      format.js { render :partial => 'lista_de_estados', :object => @estados }
    end
  end
  
  def index_nivel_dos
    @usuario = current_user
    @plaza = @usuario.plaza
    @modelos=["servicio", "paquete"]
  end
  
  # Responde con un cambio en el selector de plazas cada vez que se selecciona un estado
  def estado_seleccionado
    estado_id = params[:id].gsub(/\D/,'')
    render(:text => "<i>Selecciona un estado</i>") && return if estado_id.blank?
    estado = Estado.find estado_id
    @plazas = estado.plazas
    respond_to do |format|
      format.js do
        render :partial => 'selector_de_plaza', :object => @plazas
      end
    end
  end
  
  # Responde desplegando una plaza, su estado, y una lista de categorias de donde escoger
  # para ver los servicios relacionados a la plaza
  def plaza_seleccionada
    if params[:id].empty?
      render :update do |page|
        page["estado_de_seleccion"].replace_html "Seleccionar:"
        page["contenedor_cambiante"].visual_effect :fade, :duration => 3
      end
      return
    end
    
    plaza_id = params[:id].gsub(/\D/,'')
    render(:nothing => true) && return if plaza_id.blank?
    @plaza = Plaza.find plaza_id
    cookies['plaza'] = {:value => @plaza.id}
    @paquetes = @plaza.paquetes
    @metaservicios = Metaservicio.all
    respond_to do |format|
      format.js do   
        render :update do |page|
          page["estado_de_seleccion"].replace_html "Seleccionado:"
          page["contenedor_cambiante"].replace_html :partial => 'contenido_de_plaza'
          page["contenedor_cambiante"].visual_effect :appear, :duration => 3
        end
      end
    end
  end
  
  # Seleccionado un metaservicio, se procede a desplegar la lista de metasubservicios asociados
  def metaservicio_seleccionado
    metaservicio_id = params[:id].gsub(/\D/,'')
    metasubservicios = Metasubservicio.find(:all, :conditions => {:metaservicio_id => metaservicio_id})
    respond_to do |format|
      format.js do
        render :update do |page|
          page['listado_de_preservicios'].replace_html :partial => 'lista_de_metasubservicios', 
                                                       :locals => {:metasubservicios => metasubservicios,
                                                                   :metaservicio_id => metaservicio_id}
          page['listado_de_preservicios'].visual_effect :appear
          page << "Nifty('#listado_de_preservicios', 'bottom tr');"
        end
      end
    end
  end
  
  # Click en link 'atrás' en el listado de metasubservicios, recarga y después despliega la lista de metaservicios
  def recarga_metaservicios
    metaservicios = Metaservicio.all
    respond_to do |format|
      format.js do
        render :update do |page|
          page['listado_de_preservicios'].replace_html :partial => 'lista_de_metaservicios', 
                                                       :locals => {:metaservicios => metaservicios}
          page['listado_de_preservicios'].visual_effect :appear
          page << "Nifty('#listado_de_preservicios', 'bottom tr');"
        end
      end
    end
  end
  
  # Seleccionado un metasubservicio, se procede a desplegar la tabla de conceptos para los servicios que tengan
  # ese metasubservicio
  def metasubservicio_seleccionado
    metasubservicio_id = params[:id].gsub(/\D/,'')
    plaza_id = cookies['plaza'].gsub(/\D/,'')
    @servicios = Servicio.find(:all, :conditions => {:metasubservicio_id => metasubservicio_id, :plaza_id => plaza_id})
    respond_to do |format|
      format.js do
        render :update do |page|
          page['plaza_servicios'].replace_html :partial => 'plaza_servicios'
          page['plaza_servicios'].visual_effect :appear
        end
      end
    end
  end
  
end
