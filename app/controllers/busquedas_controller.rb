class BusquedasController < ApplicationController

  # Método principal para realizar búsquedas sobre todos los modelos
  def inicial
    @resultados = Hash.new
    
    @cosa_a_buscar=params[:query]
    render(:nothing => true) && return if @cosa_a_buscar.blank?
    trozos_de_busqueda=@cosa_a_buscar.split(" ")
    @cuenta = 0
    ["Servicio", "Plaza", "Paquete", "Estado"].each do |modelo|
      resultados_en_bruto = modelo.constantize.busca(trozos_de_busqueda)
      @resultados[resultados_en_bruto.delete_at(0)] = resultados_en_bruto
      @cuenta += resultados_en_bruto.size
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
