class ConceptoClon < ActiveRecord::Base
  belongs_to :servicio_clon
  
  def disponibilidad
    return "Sí" if disponible
    "No"
  end
  
  def costo_
    return "$ #{costo.to_s(2)}" if metaconcepto_es_tipo_a? && disponible
    "-"
  end
  
  def valor_
    return valor if metaconcepto_es_tipo_b? && disponible
    "-"
  end
  
  def metaconcepto_es_tipo_a?
    metaconcepto_tipo.eql? "A"
  end
  
  def metaconcepto_es_tipo_b?
    metaconcepto_tipo.eql? "B"
  end
  
end