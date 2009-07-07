class MetasubserviciosController < ApplicationController
  
  before_filter do |controller|
    controller.usuario_es?(:administrador)
  end
  
  # GET /metaconceptos/new.js
  def new
    @metaservicios = Metaservicio.find(:all, :order => 'nombre ASC')
    super
  end

  # GET /categorias/1/edit
  def edit
     @metaservicios = Metaservicio.find(:all, :order => 'nombre ASC')
     super
  end
  
end
