class PaquetesController < ApplicationController
    
  before_filter :only => [:some] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 podrán ejecutar la acción definida
    # en "only"
    controller.nivel_logged_in(["nivel 1"])
  end
  
  before_filter :only => [:new, :create, :edit, :update, :destroy] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1", "nivel 2"])
  end
  
  # GET /paquetes
  # GET /paquetes.xml
  def index
    @paquetes = Paquete.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @paquetes }
    end
  end
  
  def edit
    @plaza = current_user.responsabilidad
    super
  end

  # GET /paquetes/1
  # GET /paquetes/1.xml
  def show
    @paquete = Paquete.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paquete }
    end
  end

  # GET /paquetes/new
  # GET /paquetes/new.xml
  def new
    @plaza = current_user.responsabilidad
    super
  end

end
