class PaquetesController < ApplicationController
  
  before_filter :only => [:some] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 podrán ejecutar la acción definida
    # en "only"
    controller.nivel_logged_in(["nivel 1"])
  end
  
  before_filter :only => [:new, :create, :edit, :update, :destroy, :separar_objetos, :listado_de_servicios] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1", "nivel 2"])
  end
  
  # GET /paquetes
  # GET /paquetes.xml
  def index
    @paquetes = Paquete.paginate :all, :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @paquetes }
    end
  end

  def some
    tipo = params[:tipo]
    instance_variable_set "@#{tipo.downcase}", tipo.constantize.find(params[:id])
    if tipo.eql? "Plaza"
      @paquetes = Paquete.paginate :all, :joins => :plazas, :conditions => {:paquetes_plazas => {:plaza_id => params[:id]}}, :page => params[:page] 
    else
      @paquetes = Paquete.paginate :all, :joins => "#{tipo.downcase.pluralize}".to_sym, :conditions => {"#{tipo.downcase.pluralize}".to_sym => {:id => params[:id]}}, :page => params[:page]
    end
    respond_to do |format|
      format.html { render 'index.html.erb', :layout => 'application_layout' }
    end
  end

  # GET /paquetes/1
  # GET /paquetes/1.xml
  def show
    @obj = Paquete.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /paquetes/new
  # GET /paquetes/new.xml
  def new
    @paquete = Paquete.new
    @categorias = Categoria.find :all
    
    respond_to do |format|
      format.html { session[:incorporados_paquete]=nil }
      format.js { render :partial => params[:partial] }
    end
  end

  # GET /paquetes/1/edit
  def edit
    @paquete = Paquete.find(params[:id])
    @categorias = Categoria.find :all
    
    respond_to do |format|
      format.html { session[:incorporados_paquete]=nil }
      format.js { render :partial => params[:partial] }
    end
  end

  # POST /paquetes
  # POST /paquetes.xml
  def create
    @paquete = Paquete.new(params[:paquete])
    params[:incorporados] = session[:incorporados_paquete]
    
    @paquete.agrega_desde(params)

    respond_to do |format|
      if @paquete.save
        flash[:notice] = 'Paquete was successfully created.'
        format.html { redirect_to(@paquete) }
        format.xml  { render :xml => @paquete, :status => :created, :location => @paquete }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /paquetes/1
  # PUT /paquetes/1.xml
  def update
    @paquete = Paquete.find(params[:id])
    params[:incorporados] = session[:incorporados_paquete]
    
    @paquete.agrega_desde(params, :update)

    respond_to do |format|
      if @paquete.update_attributes(params[:paquete])
        flash[:notice] = 'Paquete was successfully updated.'
        format.html { redirect_to(@paquete) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /paquetes/1
  # DELETE /paquetes/1.xml
  def destroy
    @paquete = Paquete.find(params[:id])
    @paquete.destroy

    respond_to do |format|
      format.html { redirect_to(paquetes_url) }
    end
  end

  # Desliga dos objetos relacionados
  def separar_objetos
     id_super, submodelo, id_sub, identificador = recibir_parametros_comunes

     @subM=submodelo.capitalize.constantize.find(id_sub)
     @paquete=Paquete.find(id_super)
     eval("@paquete.#{submodelo.pluralize.downcase}.delete(@subM)")

     respond_to do |format|
       format.js do
         render :update do |page|
           page.replace_html identificador, ""
         end
       end
     end
   end

    def listado_de_servicios
      if params[:paquete].blank?
        paquete_id= "" 
      else
        paquete_id= params[:paquete]
        @paquete = Paquete.find(paquete_id)
      end 
      categoria_id=params[:id]
      @incorporados = Incorporado.paginate :all, :joins => [:servicio => :categoria], 
                        :conditions => ["servicios.categoria_id = ? AND (paquete_id IS NULL OR paquete_id = ?)", categoria_id, paquete_id], 
                        :page => params[:page], :per_page => 3
      respond_to do |format|
        format.js { render :partial => 'listado_incorporados_paquete_form' }
      end
    end
end
