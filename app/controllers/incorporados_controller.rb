class IncorporadosController < ApplicationController
  
  before_filter :only => [:new, :edit, :create, :update, :destroy] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1", "nivel 2"])
  end
  
  # GET /incorporados/new
  def new
    @incorporado = Incorporado.new

    respond_to do |format|
      format.html # new.html.erb
    # format.xml  { render :xml => @plaza }
    end
  end
  
  # GET /incorporados/1
  def show
     @incorporado = Incorporado.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
    #   format.xml  { render :xml => @incorporado }
      end
  end
  
  # GET /incorporados/1/edit
  def edit
    @incorporado = Incorporado.find(params[:id])
  end
  
  # DELETE /incorporados/1
  def destroy
    @incorporado = Incorporado.find(params[:id])
    @incorporado.destroy

    respond_to do |format|
      format.html { redirect_to(plazas_url) }
    end
  end
  
  # POST /incorporados
  def create
    @incorporado = Incorporado.new(params[:incorporado])
    
    respond_to do |format|
      if @incorporado.save
        flash[:notice] = 'Incorporado was successfully created.'
        format.html { redirect_to(@incorporado) }
      #  format.xml  { render :xml => @plaza, :status => :created, :location => @plaza }
      else
        format.html { render :action => "new" }
      #  format.xml  { render :xml => @plaza.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @incorporado = Incorporado.find(params[:id])
    
    respond_to do |format|
      if @incorporado.update_attributes(params[:incorporado])
        flash[:notice] = 'Incorporado actualizado con éxito.'
        format.html { redirect_to(@incorporado) }
     #   format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
    #    format.xml  { render :xml => @rol.errors, :status => :unprocessable_entity }
      end
    end
  end
end