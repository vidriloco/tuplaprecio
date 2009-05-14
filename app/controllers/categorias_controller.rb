class CategoriasController < ApplicationController
  
  before_filter do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1"])
  end
  
  # GET /categorias
  # GET /categorias.xml
  def index
    @categorias = Categoria.paginate :all, :page => params[:page] 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categorias }
    end
  end
  
  def some
    tipo = params[:tipo]
    instance_variable_set "@#{tipo.downcase}", tipo.constantize.find(params[:id])
    if tipo.eql? "Concepto"
        @categorias = Categoria.paginate :all, :joins => :conceptos, :conditions => {:categorias_conceptos => {:concepto_id => params[:id]}}, :page => params[:page]
        #@categorias = Categoria.paginate_by_sql ["SELECT * FROM 'categorias' INNER JOIN 'categorias_conceptos' ON
        #'categorias'.id = 'categorias_conceptos'.categoria_id WHERE ('categorias_conceptos'.concepto_id = ? )", params[:id]], :page => params[:page]
    elsif tipo.eql? "Servicio"
        @categorias = Categoria.paginate :all, :joins => :servicios, :conditions => {:servicios => {:id => params[:id]}}, :page => params[:page]
    end
    respond_to do |format|
      format.html { render 'index.html.erb', :layout => 'application_layout' }
    end
  end

  # GET /categorias/1
  # GET /categorias/1.xml
  def show
    @obj = Categoria.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @obj }
    end
  end

  # GET /categorias/new
  # GET /categorias/new.xml
  def new
    @categoria = Categoria.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @categoria }
    end
  end

  # GET /categorias/1/edit
  def edit
    @categoria = Categoria.find(params[:id])
  end

  # POST /categorias
  # POST /categorias.xml
  def create
    @categoria = Categoria.new(params[:categoria])

    respond_to do |format|
      if @categoria.save
        flash[:notice] = 'Categoria was successfully created.'
        format.html { redirect_to(@categoria) }
        format.xml  { render :xml => @categoria, :status => :created, :location => @categoria }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @categoria.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categorias/1
  # PUT /categorias/1.xml
  def update
    @categoria = Categoria.find(params[:id])

    respond_to do |format|
      if @categoria.update_attributes(params[:categoria])
        flash[:notice] = 'Categoria was successfully updated.'
        format.html { redirect_to(@categoria) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @categoria.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categorias/1
  # DELETE /categorias/1.xml
  def destroy
    @categoria = Categoria.find(params[:id])
    @categoria.destroy

    respond_to do |format|
      format.html { redirect_to(categorias_url) }
      format.xml  { head :ok }
    end
  end
  
  # Desliga dos objetos relacionados
  def separar_objetos
    id_super, submodelo, id_sub, identificador = recibir_parametros_comunes
    
    @subM=submodelo.capitalize.constantize.find(id_sub)
    @categoria=Categoria.find(id_super)
    eval("@categoria.#{submodelo.pluralize.downcase}.delete(@subM)")
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html identificador, ""
        end
      end
    end
  end
  
end
