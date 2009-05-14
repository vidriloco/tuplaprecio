class ConceptosController < ApplicationController
  
  before_filter do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1"])
  end
  
  # GET /conceptos
  # GET /conceptos.xml
  def index
    @conceptos = Concepto.paginate :all, :page => params[:page] 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @conceptos }
    end
  end
  
  def some
    tipo = params[:tipo]
    instance_variable_set "@#{tipo.downcase}", tipo.constantize.find(params[:id])
    if tipo.eql? "Servicio"
      @conceptos = Concepto.paginate :all, :joins => :servicios, :conditions => {:servicios => {:id => params[:id]}}, :page => params[:page]
    elsif tipo.eql? "Categoria"
      @conceptos = Concepto.paginate :all, :joins => :categorias, :conditions => {:categorias_conceptos => {:categoria_id => params[:id]}}, :page => params[:page]
    end
    respond_to do |format|
      format.html { render 'index.html.erb', :layout => 'application_layout' }
    end
  end

  # GET /conceptos/1
  # GET /conceptos/1.xml
  def show
    @obj = Concepto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @obj }
    end
  end

  # GET /conceptos/new
  # GET /conceptos/new.xml
  def new
    @concepto = Concepto.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @concepto }
    end
  end

  # GET /conceptos/1/edit
  def edit
    @concepto = Concepto.find(params[:id])
  end

  # POST /conceptos
  # POST /conceptos.xml
  def create
    @concepto = Concepto.new(params[:concepto])
    @concepto.agrega_desde(params)
    respond_to do |format|
      if @concepto.save
        flash[:notice] = 'Concepto was successfully created.'
        format.html { redirect_to(@concepto) }
        format.xml  { render :xml => @concepto, :status => :created, :location => @concepto }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @concepto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /conceptos/1
  # PUT /conceptos/1.xml
  def update
    @concepto = Concepto.find(params[:id])
    @concepto.agrega_desde(params, :update)
    respond_to do |format|
      if @concepto.update_attributes(params[:concepto])
        flash[:notice] = 'Concepto was successfully updated.'
        format.html { redirect_to(@concepto) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @concepto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /conceptos/1
  # DELETE /conceptos/1.xml
  def destroy
    @concepto = Concepto.find(params[:id])
    @concepto.destroy

    respond_to do |format|
      format.html { redirect_to(conceptos_url) }
      format.xml  { head :ok }
    end
  end
  
  # Desliga dos objetos relacionados
  def separar_objetos
    id_super, submodelo, id_sub, identificador = recibir_parametros_comunes
    
    @subM=submodelo.capitalize.constantize.find(id_sub)
    @concepto=Concepto.find(id_super)
    eval("@concepto.#{submodelo.pluralize.downcase}.delete(@subM)")
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html identificador, ""
        end
      end
    end
  end
end
