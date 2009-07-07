class PlazasController < ApplicationController
  
  before_filter do |controller|
    controller.usuario_es?(:administrador)
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
