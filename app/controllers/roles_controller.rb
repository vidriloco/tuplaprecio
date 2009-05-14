class RolesController < ApplicationController
  
  before_filter do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1"])
  end
  
  # GET /conceptos
  # GET /conceptos.xml
  def index
    @roles = Rol.paginate :all, :page => params[:page] 

    respond_to do |format|
      format.html # index.html.erb
    #  format.xml  { render :xml => @roles }
    end
  end
  
  # GET /roles/new
  # GET /roles/new.xml
  def new
    @rol = Rol.new

    respond_to do |format|
      format.html # new.html.erb
   #   format.xml  { render :xml => @rol }
    end
  end
  
  # GET /roles/1
  # GET /roles/1.xml
  def show
    @rol = Rol.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
  #   format.xml  { render :xml => @rol }
    end
  end
  
  # GET /roles/1/edit
  def edit
    @rol = Rol.find(params[:id])
  end
  
  # POST /roles
  # POST /roles.xml
  def create
    @rol = Rol.new(params[:rol])

    respond_to do |format|
      if @rol.save
        flash[:notice] = 'Rol creado con éxito.'
        format.html { redirect_to(@rol) }
   #     format.xml  { render :xml => @rol, :status => :created, :location => @rol }
      else
        format.html { render :action => "new" }
    #    format.xml  { render :xml => @rol.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    @rol = Rol.find(params[:id])
    
    respond_to do |format|
      if @rol.update_attributes(params[:rol])
        flash[:notice] = 'Rol actualizado con éxito.'
        format.html { redirect_to(@rol) }
     #   format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
    #    format.xml  { render :xml => @rol.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @rol = Servicio.find(params[:id])
    @rol.destroy

    respond_to do |format|
      format.html { redirect_to(roles_url) }
     # format.xml  { head :ok }
    end
  end
end
