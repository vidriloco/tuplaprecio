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
      @instancias = @plaza.paquetes.inject([]) { |n,paquete| n+=paquete.incorporados }
    else
      @instancias =eval("@plaza.#{modelo.pluralize.downcase}")
    end
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html "tablero-recargable", :partial => 'compartidos/verModelo', :locals => {:obj_desp => @instancias, :tipo => modelo}
        end
      end
    end
  end
end
