class BusquedasController < ApplicationController
  
  # Método principal para realizar búsquedas sobre todos los modelos
  def inicial
    @cosa_a_buscar=params[:query].gsub(/\d/,'')
    @resultados=FulltextRow.search(@cosa_a_buscar, :only => [:servicio, :plaza, :concepto, :categoria, :paquete, :incorporado, :estado], :limit => 10, :offset => 0)
    
    respond_to do |format|
      format.js { render :partial => 'resultados'}
    end
  end
  
  # Despliega detalles del objeto seleccionado en el resultado de la búsqueda
  def detalle
    objeto_id=params[:id].gsub(/\D/,'')
    tipo=params[:tipo]
    obj_desp=tipo.constantize.find(objeto_id)
    
    render :update do |page|
      page.replace_html 'detallados_contenedor', :partial => 'detalles_contenedor', 
                                                 :locals => {:obj_desp => [obj_desp], :tipo => tipo,
                                                 :div_act => 'detallados_contenedor'}
      page.visual_effect :appear, 'detallados_contenedor'
    end
  end
end
