class EspecializadosController < ApplicationController

  before_filter :only => [:new, :edit, :create, :update, :destroy] do |controller|
    # Invocando filtro "nivel_logged_in". Sólo usuarios de nivel 1 y 2 podrán ejecutar las acciones
    # definidas en "only"
    controller.nivel_logged_in(["nivel 1", "nivel 2"])
  end

  # GET /especializados/new
   def new
     @especializado = Especializado.new

     respond_to do |format|
       format.html # new.html.erb
     # format.xml  { render :xml => @plaza }
     end
   end

   def index 
     @especializados = Especializado.paginate :all, :page => params[:page]
   end

   def some
     tipo = params[:tipo]
     instance_variable_set "@#{tipo.downcase}", tipo.constantize.find(params[:id])
     @especializados = eval("Especializado.paginate_by_#{tipo.downcase}_id @#{tipo.downcase}.id, :page => params[:page]")
     respond_to do |format|
       format.html { render 'index.html.erb', :layout => 'application_layout' }
     end
   end

   # GET /especializados/1
   def show
      @especializado = Especializado.find(params[:id])

       respond_to do |format|
         format.html # show.html.erb
     #   format.xml  { render :xml => @especializado }
       end
   end

   # GET /especializados/1/edit
   def edit
     @especializado = Especializado.find(params[:id])
   end

   # DELETE /especializados/1
   def destroy
     @especializado = Especializado.find(params[:id])
     @especializado.destroy

     respond_to do |format|
       format.html { redirect_to(plazas_url) }
     end
   end

   # POST /especializados
   def create
     @especializado = Especializado.new(params[:especializado])

     respond_to do |format|
       if @especializado.save
         flash[:notice] = 'Especializado was successfully created.'
         format.html { redirect_to(@especializado) }
       #  format.xml  { render :xml => @plaza, :status => :created, :location => @plaza }
       else
         format.html { render :action => "new" }
       #  format.xml  { render :xml => @plaza.errors, :status => :unprocessable_entity }
       end
     end
   end

   def update
     @especializado = Especializado.find(params[:id])

     respond_to do |format|
       if @especializado.update_attributes(params[:especializado])
         flash[:notice] = 'Especializado actualizado con éxito.'
         format.html { redirect_to(@especializado) }
      #   format.xml  { head :ok }
       else
         format.html { render :action => "edit" }
     #    format.xml  { render :xml => @rol.errors, :status => :unprocessable_entity }
       end
     end
   end

end