class TablerosController < ApplicationController
  
  def index
    @usuario = Usuario.find(session[:usuario_id])
    @plaza = @usuario.responsabilidad
    @tareas = ["especializado", "paquete"]
  end
  
  def lista_ajax
    @plaza = Plaza.find params[:id].gsub(/\D/,'')
    modelo = params[:modelo]
    if modelo.eql? 'Incorporado'
      @instancias = Incorporado.paginate :all, :joins => {:paquete => :plazas}, :conditions => {:paquetes_plazas => {:plaza_id => @plaza.id}}, :page => params[:page]
    elsif modelo.eql? 'Paquete'
      @instancias = Paquete.paginate :all, :joins => :plazas, :conditions => {:paquetes_plazas => {:plaza_id => @plaza.id}}, :page => params[:page]
    elsif modelo.eql? 'Especializado'
      @instancias = Especializado.paginate :all, :joins => :plaza, :conditions => {:plaza_id => @plaza.id}, :page => params[:page]
    end
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "tablero-recargable", :partial => 'verAsociados', :locals => {:obj_desp => @instancias, :modelo => modelo, :plaza_id=> @plaza.id}
        end
      end
    end
  end
end
