class PlazasController < ApplicationController
  
  before_filter :except => [:edit, :update, :show] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1"])
  end
  
  before_filter :only => [:edit, :update, :show] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1","nivel 2"])
  end
  
  # GET /plazas
  # GET /plazas.xml
  def index
    @plazas = Plaza.paginate :all, :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @plazas }
    end
  end
  
  def some
    tipo = params[:tipo]
    instance_variable_set "@#{tipo.downcase}", tipo.constantize.find(params[:id])
    if tipo.eql? "Paquete"
      #@plazas = Plaza.paginate_by_sql ["SELECT * FROM 'plazas' INNER JOIN 'paquetes_plazas'
      #   ON 'plazas'.id = 'paquetes_plazas'.plaza_id WHERE ('paquetes_plazas'.paquete_id = ? )", params[:id]], :page => params[:page]
      @plazas = Plaza.paginate :all, :joins => :paquetes, :conditions => {:paquetes_plazas => {:paquete_id => params[:id]}}, :page => params[:page]
      
    else
      @plazas = eval("Plaza.paginate_by_#{tipo.downcase}_id @#{tipo.downcase}.id, :page => params[:page]")
    end
    respond_to do |format|
      format.html { render 'index.html.erb', :layout => 'application_layout' }
    end
  end

  # GET /plazas/1
  # GET /plazas/1.xml
  def show
    @obj = Plaza.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @obj }
    end
  end

  # GET /plazas/new
  # GET /plazas/new.xml
  def new
    @plaza = Plaza.new

    respond_to do |format|
      format.html # new.html.erb
   #  format.xml  { render :xml => @plaza }
    end
  end

  # GET /plazas/1/edit
  def edit
    @plaza = Plaza.find(params[:id])
  end

  # POST /plazas
  # POST /plazas.xml
  def create
    @plaza = Plaza.new(params[:plaza])
    @plaza.agrega_desde(params)
    
    respond_to do |format|
      if @plaza.save
        flash[:notice] = 'Plaza was successfully created.'
        format.html { redirect_to(@plaza) }
        format.xml  { render :xml => @plaza, :status => :created, :location => @plaza }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @plaza.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /plazas/1
  # PUT /plazas/1.xml
  def update
    @plaza = Plaza.find(params[:id])
    @plaza.agrega_desde(params, :update)
    
    respond_to do |format|
      if @plaza.update_attributes(params[:plaza])
        flash[:notice] = 'Plaza was successfully updated.'
        format.html { redirect_to(@plaza) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @plaza.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /plazas/1
  # DELETE /plazas/1.xml
  def destroy
    @plaza = Plaza.find(params[:id])
    @plaza.destroy

    respond_to do |format|
      format.html { redirect_to(plazas_url) }
      format.xml  { head :ok }
    end
  end
  
  def separar_objetos
    id_super, submodelo, id_sub, identificador = recibir_parametros_comunes
    
    @subM=submodelo.capitalize.constantize.find(id_sub)
    @plaza=Plaza.find(id_super)
    if submodelo.eql? 'Estado'
      eval("@plaza.#{submodelo.downcase}=nil")
      @plaza.save!
    else
      eval("@plaza.#{submodelo.pluralize.downcase}.delete(@subM)")
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
