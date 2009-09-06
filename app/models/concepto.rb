class Concepto < ActiveRecord::Base
  include Compartido
  
  belongs_to :metaconcepto
  belongs_to :servicio
  
  validates_presence_of :metaconcepto_id
  validates_numericality_of :costo, :if => :metaconcepto_es_tipo_a?, :unless => :no_disponible?
  validates_numericality_of :valor, :if => :metaconcepto_es_tipo_b?, :unless => :no_disponible?
  validates_presence_of :costo, :if => :metaconcepto_es_tipo_a?, :unless => :no_disponible?
  validates_presence_of :valor, :if => :metaconcepto_es_tipo_b?, :unless => :no_disponible?
  
  # Atributos cuyos valores relativos a cada instancia de éste modelo serán traducidos a código ruby en un archivo para exportar como copia de seguridad
  def self.atributos_exportables
    [:disponible, :valor, :costo, :comentarios]
  end
  
  # Necesario para poder obtener CSVs de éste modelo
  acts_as_reportable  
  
  def metaconcepto_es_tipo_a?
    return true if metaconcepto.nil?
    metaconcepto.tipo.eql? "A"
  end
  
  def metaconcepto_es_tipo_b?
    return true if metaconcepto.nil?
    metaconcepto.tipo.eql? "B"
  end
  
  # Método que devuelve el estado de disponibilidad de un concepto
  def no_disponible?
    return true unless disponible
    false
  end
    
  def self.per_page
    5
  end
  
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
  
  def metaconcepto_asociado
    metaconcepto
  end
  
end
