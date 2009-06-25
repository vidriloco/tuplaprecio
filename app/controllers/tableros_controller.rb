class TablerosController < ApplicationController
  
  before_filter :only => [:index_nivel_tres] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 3"])
  end
  
  before_filter :only => [:index_nivel_dos] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 2"])
  end
  
  
  def index_nivel_tres
    @usuario = current_user
    @estados = Estado.paginate :all, :page => params[:page], :per_page => 6
    respond_to do |format|
      format.html
      format.js { render :partial => 'lista_de_estados', :object => @estados }
    end
  end
  
  def index_nivel_dos
    @usuario = current_user
    @plaza = @usuario.responsabilidad
    @modelos=["servicio", "paquete"]
  end
  
  # Responde con un cambio en el selector de plazas cada vez que se selecciona un estado
  def estado_seleccionado
    estado_id = params[:estado_id].gsub(/\D/,'')
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
    plaza_id = params[:plaza_id].gsub(/\D/,'')
    render(:nothing => true) && return if plaza_id.blank?
    @plaza = Plaza.find plaza_id
    @paquetes = @plaza.paquetes
    @servicios = @plaza.servicios
    @metaservicios = Metaservicio.all
    respond_to do |format|
      format.js do
        render :partial => 'contenido_de_plaza'
      end
    end
  end
  
  # Responde con una lista de servicios relacionados a una categoria bajo una plaza dada
  def despliega_servicios_de_categoria
    categoria_id = params[:categoria_id].gsub(/\D/,'')
    plaza_id = params[:plaza_id].gsub(/\D/,'')
    @incorporados =Especializado.find :all, :joins => [:plaza, {:servicio => :categoria}], 
                                 :include => [{:servicio => [:concepto, :categoria]}],
                                 :conditions => {:plaza_id => plaza_id, :servicios => {:categoria_id => categoria_id}}

    respond_to do |format|
      format.js do
        render :partial => 'servicios_de_categoria'
      end
    end
  end
  
  
  
end
