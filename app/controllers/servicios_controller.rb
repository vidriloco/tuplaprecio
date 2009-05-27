class ServiciosController < ApplicationController
  
  before_filter :only => [:some] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 podrán ejecutar la acción definida
    # en "only"
    controller.nivel_logged_in(["nivel 1"])
  end
  
  before_filter :only => [:new, :create, :edit, :update, :destroy, :update_conceptos, :separar_objetos] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1", "nivel 2"])
  end
  
  
  # GET /servicios
  # GET /servicios.xml
  def index
    @servicios = Servicio.paginate :all, :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
    #  format.xml  { render :xml => @servicios }
    end
  end
  
  # Pagina objetos relacionados a un objeto previo
  def some
    tipo = params[:tipo]
    instance_variable_set "@#{tipo.downcase}", tipo.constantize.find(params[:id])
    if tipo.eql?("Concepto") || tipo.eql?("Categoria")
      @servicios = eval("Servicio.paginate_by_#{tipo.downcase}_id @#{tipo.downcase}.id, :page => params[:page]")
    # paginación para: [paquete, especializado, plaza, incorporado]  
    else
      @servicios = Servicio.paginate :all, :joins => "#{tipo.downcase.pluralize}".to_sym, :conditions => {"#{tipo.downcase.pluralize}".to_sym => {:id => params[:id]}}, :page => params[:page]
    end
    respond_to do |format|
      format.html { render 'index.html.erb' }
    end
  end
  

  # GET /servicios/1
  # GET /servicios/1.xml
  def show
    @obj = Servicio.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
     # format.xml  { render :xml => @obj }
    end
  end

  # GET /servicios/new
  # GET /servicios/new.xml
  def new
    @servicio = Servicio.new
    respond_to do |format|
      format.html # new.html.erb
    #  format.xml  { render :xml => @servicio }
    end
  end

  # GET /servicios/1/edit
  def edit
    @servicio = Servicio.find(params[:id])
  end

  # POST /servicios
  # POST /servicios.xml
  def create
    @servicio = Servicio.new(params[:servicio])
    
    respond_to do |format|
      if @servicio.save
        flash[:notice] = 'Servicio was successfully created.'
        format.html { redirect_to(@servicio) }
       # format.xml  { render :xml => @servicio, :status => :created, :location => @servicio }
      else
        format.html { render :action => "new" }
      #  format.xml  { render :xml => @servicio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /servicios/1
  # PUT /servicios/1.xml
  def update
    @servicio = Servicio.find(params[:id])
    
    respond_to do |format|
      if @servicio.update_attributes(params[:servicio])
        flash[:notice] = 'Servicio was successfully updated.'
        format.html { redirect_to(@servicio) }
      #  format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
      #  format.xml  { render :xml => @servicio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /servicios/1
  # DELETE /servicios/1.xml
  def destroy
    @servicio = Servicio.find(params[:id])
    @servicio.destroy

    respond_to do |format|
      format.html { redirect_to(servicios_url) }
     # format.xml  { head :ok }
    end
  end
  
  # Actualiza la lista de selección de conceptos cuando se ha seleccionado una categoria 
  # en los formularios new y edit de servicio.
  def update_conceptos
    categoria = Categoria.find params[:categoria_servicio].gsub(/\D/,'')
    conceptos = categoria.conceptos
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "concepto_changer", :partial => "concepto_form", :locals => {:conceptos => conceptos}
        end
      end
    end
  end
  
  # Desliga objetos relacionados a un objeto
  def separar_objetos
    id_super, submodelo, id_sub, identificador = recibir_parametros_comunes
    
    @subM=submodelo.capitalize.constantize.find(id_sub)
    @servicio=Servicio.find(id_super)
    if submodelo.eql? 'Concepto'
      eval("@servicio.#{submodelo.downcase}=nil")
      @servicio.save!
    elsif submodelo.eql? 'Categoria'
      eval("@servicio.#{submodelo.downcase}=nil")
      @servicio.save!
    else
      eval("@servicio.#{submodelo.pluralize.downcase}.delete(@subM)")
    end
    
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html identificador, ""
        end
      end
    end
  end
end
