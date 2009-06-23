class Concepto < ActiveRecord::Base
  include Compartido
  
  belongs_to :metaconcepto
  belongs_to :servicio
  validates_numericality_of :costo, :if => :metaconcepto_es_tipo_a?
  validates_numericality_of :valor, :if => :metaconcepto_es_tipo_b?
  validates_presence_of :costo, :if => :metaconcepto_es_tipo_a?
  validates_presence_of :valor, :if => :metaconcepto_es_tipo_b?
    
  def metaconcepto_es_tipo_a?
    return true if metaconcepto.nil?
    metaconcepto.tipo.eql? "A"
  end
  
  def metaconcepto_es_tipo_b?
    return true if metaconcepto.nil?
    metaconcepto.tipo.eql? "B"
  end
    
  def self.per_page
    5
  end
  
  def costo_
    return "$ #{costo} pesos"
  end
  
  def disponibilidad
    return "Sí" if disponible
    "No"
  end
  
  def costo_
    return "$ #{costo} pesos" if metaconcepto_es_tipo_a?
    "-"
  end
  
  def valor_
    return valor if metaconcepto_es_tipo_b?
    "-"
  end
  
  def metaconcepto_asociado
    metaconcepto
  end
  
end
