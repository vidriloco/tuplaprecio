class PaquetesController < ApplicationController
  
  before_filter :only => [:some] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 podrán ejecutar la acción definida
    # en "only"
    controller.nivel_logged_in(["nivel 1"])
  end
  
  before_filter :only => [:new, :create, :edit, :update, :destroy, :separar_objetos] do |controller|
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
      @paquetes = Paquete.paginate_by_sql ["SELECT * FROM 'paquetes' INNER JOIN 'paquetes_plazas' ON 
        'paquetes'.id = 'paquetes_plazas'.paquete_id WHERE ('paquetes_plazas'.plaza_id = ? )", params[:id]], :page => params[:page]
    else
      @paquetes = instance_variable_get("@#{tipo.downcase}").paquetes
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
      format.xml  { render :xml => @obj }
    end
  end

  # GET /paquetes/new
  # GET /paquetes/new.xml
  def new
    @paquete = Paquete.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @paquete }
    end
  end

  # GET /paquetes/1/edit
  def edit
    @paquete = Paquete.find(params[:id])
  end

  # POST /paquetes
  # POST /paquetes.xml
  def create
    @paquete = Paquete.new(params[:paquete])
    @paquete.agrega_desde(params)

    respond_to do |format|
      if @paquete.save
        flash[:notice] = 'Paquete was successfully created.'
        format.html { redirect_to(@paquete) }
        format.xml  { render :xml => @paquete, :status => :created, :location => @paquete }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paquete.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /paquetes/1
  # PUT /paquetes/1.xml
  def update
    @paquete = Paquete.find(params[:id])
    @paquete.agrega_desde(params, :update)

    respond_to do |format|
      if @paquete.update_attributes(params[:paquete])
        flash[:notice] = 'Paquete was successfully updated.'
        format.html { redirect_to(@paquete) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paquete.errors, :status => :unprocessable_entity }
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
      format.xml  { head :ok }
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
end
