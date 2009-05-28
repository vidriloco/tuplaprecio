class BusquedasController < ApplicationController
  
  # Método principal para realizar búsquedas sobre todos los modelos
  def inicial
    @resultados = Array.new
    
    @cosa_a_buscar=params[:query]
    trozos_de_busqueda=@cosa_a_buscar.split(" ")
    
    ["Servicio", "Plaza", "Concepto", "Categoria", "Paquete", "Incorporado", "Estado"].each do |modelo|
      @resultados += modelo.constantize.busca(trozos_de_busqueda)
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
