class MetaconceptosController < ApplicationController

  before_filter do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1"])
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
