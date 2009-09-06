class CoberturasController < ApplicationController
  
  before_filter :only => [:new, :create, :edit, :update, :destroy] do |controller|
    controller.usuario_es?(:encargado)
  end
  
  before_filter :exporta_usuario_actual, :only => [:create, :update, :destroy]
  
  # GET /coberturas
  # GET /coberturas.xml
  def index
    @coberturas = Cobertura.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @coberturas }
    end
  end

  # GET /coberturas/1
  # GET /coberturas/1.xml
  def show
    @cobertura = Cobertura.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cobertura }
    end
  end

  # GET /coberturas/new
  # GET /coberturas/new.xml
  def new
    @cobertura = Cobertura.new
    @plaza = current_user.plaza
    super
  end

  # GET /coberturas/1/edit
  def edit
    @cobertura = Cobertura.find(params[:id])
    @plaza = current_user.plaza
    super
  end

  # POST /coberturas
  # POST /coberturas.xml
  def create
    super do
      render :update do |page|
          page["coberturas"].replace_html :partial => "tableros/index_modelo_barra", 
                                                :locals => {:modelo => "cobertura"}
          page["coberturas"].visual_effect :appear
          page << "Nifty('div#coberturas');"
      end
    end
  end

  # PUT /coberturas/1
  # PUT /coberturas/1.xml
  def update
    super do
      render :update do |page|
          page["coberturas"].replace_html :partial => "tableros/index_modelo_barra", 
                                                :locals => {:modelo => "cobertura"}
          page["coberturas"].visual_effect :appear
          page << "Nifty('div#coberturas');"
      end
    end
  end

  # DELETE /coberturas/1
  # DELETE /coberturas/1.xml
  def destroy
    super do
      render :update do |page|
         if current_user.plaza.coberturas.count == 0
           page["coberturas"].replace_html :partial => "tableros/index_modelo_barra", 
                                               :locals => {:modelo => "cobertura"}
           page["coberturas"].visual_effect :appear
           page << "Nifty('div#coberturas');"
         else   
           page["cobertura_#{params[:id]}"].visual_effect :fade
         end
       end
    end
  end
  
  def listing
    @objetos = current_user.plaza.coberturas
    render :update do |page|
      page["coberturas"].replace_html :partial => "compartidos/listing_modelos_encargado", 
                                         :locals => {:modelo => "cobertura"}
      page["coberturas"].visual_effect :appear
      page << "Nifty('div#coberturas');"
    end
  end
  
  private
    def exporta_usuario_actual
      Thread.current['usuario'] = current_user.id
    end
  
end
