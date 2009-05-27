class EstadosController < ApplicationController
  
  before_filter do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1"])
  end
  
  # GET /estados
  # GET /estados.xml
  def index
    @estados = Estado.paginate :all, :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @estados }
    end
  end

  def some
    tipo = params[:tipo]
    instance_variable_set "@#{tipo.downcase}", tipo.constantize.find(params[:id])
    @estados = [instance_variable_get("@#{tipo.downcase}").estado]
    respond_to do |format|
      format.html { render 'index.html.erb' }
    end
  end


  # GET /estados/1
  # GET /estados/1.xml
  def show
    @obj = Estado.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @obj }
    end
  end

  # GET /estados/new
  # GET /estados/new.xml
  def new
    @estado = Estado.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @estado }
    end
  end

  # GET /estados/1/edit
  def edit
    @estado = Estado.find(params[:id])
  end

  # POST /estados
  # POST /estados.xml
  def create
    @estado = Estado.new(params[:estado])

    respond_to do |format|
      if @estado.save
        flash[:notice] = 'Estado was successfully created.'
        format.html { redirect_to(@estado) }
        format.xml  { render :xml => @estado, :status => :created, :location => @estado }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @estado.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /estados/1
  # PUT /estados/1.xml
  def update
    @estado = Estado.find(params[:id])

    respond_to do |format|
      if @estado.update_attributes(params[:estado])
        flash[:notice] = 'Estado was successfully updated.'
        format.html { redirect_to(@estado) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @estado.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /estados/1
  # DELETE /estados/1.xml
  def destroy
    @estado = Estado.find(params[:id])
    @estado.destroy

    respond_to do |format|
      format.html { redirect_to(estados_url) }
      format.xml  { head :ok }
    end
  end
  
  def separar_objetos
    id_super, submodelo, id_sub, identificador = recibir_parametros_comunes
    
    @subM=submodelo.capitalize.constantize.find(id_sub)
    @estado=Estado.find(id_super)
    eval("@estado.#{submodelo.pluralize.downcase}.delete(@subM)")
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html identificador, ""
        end
      end
    end
  end
end
