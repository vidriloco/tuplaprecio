class MetaserviciosController < ApplicationController
  
  before_filter do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1"])
  end
  
  # GET /metaconceptos/new.js
  def new
    @metaconceptos = Metaconcepto.find(:all, :order => 'nombre ASC')
    super
  end

  # GET /categorias/1/edit
  def edit
     @metaconceptos = Metaconcepto.find(:all, :order => 'nombre ASC')
     super
  end
  
end
