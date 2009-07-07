class MetaconceptosController < ApplicationController

  before_filter do |controller|
    controller.usuario_es?(:administrador)
  end

  # GET /metaconceptos/new.js
  def new
    @tipos = ["A", "B"]
    super
  end
  
  # GET /metaconceptos/n/new.js
  def edit
    @tipos = ["A", "B"]
    super
  end

end
