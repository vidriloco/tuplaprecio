class PaquetesController < ApplicationController
  
  before_filter :only => [:new, :create, :edit, :update, :destroy] do |controller|
    controller.usuario_es?(:encargado)
  end
  
  before_filter :exporta_usuario_actual, :only => [:create, :update, :destroy]
  
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
    @plaza = current_user.plaza
    @zonas = Zona.all
    super
  end

  # GET /paquetes/new
  # GET /paquetes/new.xml
  def new
    @plaza = current_user.plaza
    @zonas = Zona.all
    super
  end

  def listing
    @plaza = current_user.plaza
    @objetos = @plaza.paquetes
    
    respond_to do |format|
       format.js do
         render :update do |page|
           page['paquetes'].replace_html :partial => "compartidos/listing_modelo", 
                                              :locals => {:modelo => 'paquete'}
           page['paquetes'].visual_effect :appear
           page << "Nifty('div#paquetes');"
         end
       end
    end
  end
  
  def create
    super do
      render :update do |page|
          page["paquetes"].replace_html :partial => "tableros/index_modelo_barra", 
                                                :locals => {:modelo => "paquete"}
          page["paquetes"].visual_effect :appear
          page << "Nifty('div#paquetes');"
      end
    end
  end
  
  def update
    super do
      render :update do |page|
          page["paquetes"].replace_html :partial => "tableros/index_modelo_barra", 
                                                :locals => {:modelo => "paquete"}
          page["paquetes"].visual_effect :appear
          page << "Nifty('div#paquetes');"
      end
    end
  end
  
  def destroy
    super do
      render :update do |page|
         if current_user.plaza.paquetes.count == 0
           page["paquetes"].replace_html :partial => "tableros/index_modelo_barra", 
                                               :locals => {:modelo => "paquete"}
           page["paquetes"].visual_effect :appear
           page << "Nifty('div#paquetes');"
         else   
           page["paquete_#{params[:id]}"].visual_effect :fade
         end
       end
    end
  end
  
  def listing
    @objetos = current_user.plaza.paquetes
    render :update do |page|
      page["paquetes"].replace_html :partial => "compartidos/listing_modelos_encargado", 
                                         :locals => {:modelo => "paquete"}
      page["paquetes"].visual_effect :appear
      page << "Nifty('div#paquetes');"
    end
  end
  
  private
    def exporta_usuario_actual
      Thread.current['usuario'] = current_user.id
    end

end
