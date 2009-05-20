class TablerosController < ApplicationController
  
  def index
    @usuario = Usuario.find(session[:usuario_id])
    if Administracion.nivel_de(@usuario.rol.nombre).eql? "nivel 3"
      @plazas = Plaza.paginate :all, :page => params[:page], :per_page => 7
      respond_to do |format|
        format.html
        format.js { render :partial => 'lista_de_plazas', :object => @plazas }
      end
    else
      @plaza = @usuario.responsabilidad
    end
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
  
  def selecciona_plaza
    @plaza = Plaza.find params[:id].gsub(/\D/,'')
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html 'plaza_area_contenedor', :partial => 'contenido_para_nivel_dos_y_tres', :object => @plaza
        end
      end
    end
  end
  
end
