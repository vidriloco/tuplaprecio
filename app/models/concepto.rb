class Concepto < ActiveRecord::Base
  include Compartido
  
  acts_as_reportable
  
  belongs_to :metaconcepto
  belongs_to :servicio
  validates_numericality_of :costo, :if => :metaconcepto_es_tipo_a?, :unless => :no_disponible?
  validates_numericality_of :valor, :if => :metaconcepto_es_tipo_b?, :unless => :no_disponible?
  validates_presence_of :costo, :if => :metaconcepto_es_tipo_a?, :unless => :no_disponible?
  validates_presence_of :valor, :if => :metaconcepto_es_tipo_b?, :unless => :no_disponible?
    
  def self.atributos_exportables
    [:disponible, :valor, :costo, :comentarios]
  end  
  
  def metaconcepto_es_tipo_a?
    return true if metaconcepto.nil?
    metaconcepto.tipo.eql? "A"
  end
  
  def metaconcepto_es_tipo_b?
    return true if metaconcepto.nil?
    metaconcepto.tipo.eql? "B"
  end
  
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
