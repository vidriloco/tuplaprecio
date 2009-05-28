class BusquedasController < ApplicationController
  
  # Método principal para realizar búsquedas sobre todos los modelos
  def inicial
    @cosa_a_buscar=params[:query].gsub(/\d/,'')
    @resultados = Array.new
    ["Servicio", "Plaza", "Concepto", "Categoria", "Paquete", "Incorporado", "Estado"].each do |modelo|
      @resultados += modelo.constantize.find_by_contents(@cosa_a_buscar)
    end
    
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
