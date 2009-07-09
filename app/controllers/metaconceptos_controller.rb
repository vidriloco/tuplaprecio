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
  
  def plantilla_de_ordenamiento
    @metaconceptos = Metaconcepto.find(:all, :order => "posicion ASC", :select => "id, posicion, nombre", :include => "metaservicios")
    render :partial => "plantilla_de_ordenamiento"
  end
  
  def posiciona
    if params[:value].gsub(/\D/,'').eql? ""
      render :text => "Sin posición"
      return
    end
    m=Metaconcepto.find params[:id].gsub(/\D/,'')
    if m.update_attributes(:posicion => params[:value])
      @metaconceptos = Metaconcepto.find(:all, :order => "posicion ASC", :select => "id, posicion, nombre", :include => "metaservicios")
      render :text => params[:value]
    else
      render :text => "Sin posición (Ocurrió un error al guardar)"
    end
  end

end
