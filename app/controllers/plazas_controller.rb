class PlazasController < ApplicationController
  
  before_filter :except => [:edit, :update, :show, :reset_form_sessions, :objetos_a_sesion, :listado_de_servicios] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1"])
  end
  
  before_filter :only => [:edit, :update, :show, :reset_form_sessions, :objetos_a_sesion, :listado_de_servicios] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1","nivel 2"])
  end
  
  # GET /plazas
  # GET /plazas.xml
  def index
    @plazas = Plaza.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @plazas }
    end
  end


  # GET /plazas/new
  # GET /plazas/new.xml
  def new
    @estados = Estado.find(:all)
    super
  end
  
  def edit
    @estados = Estado.find(:all)
    super
  end

end
