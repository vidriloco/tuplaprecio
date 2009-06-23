class Paquete < ActiveRecord::Base
  include Compartido
  
  belongs_to :plaza
    
  validates_presence_of :costo_1_10, :costo_11_31, :costo_real, :ahorro, :message => "no puede ser vacío"
  validates_numericality_of :costo_1_10, :costo_11_31, :costo_real, :ahorro, :message => "debe ser numérico"
  
  before_validation do |paquete|
    cuenta=0
    
    cuenta+=1 if !paquete.internet.blank?
    cuenta+=1 if !paquete.telefonia.blank?
    cuenta+=1 if !paquete.television.blank?
    
    paquete.numero_de_servicios=cuenta
  end
  
  validates_numericality_of :numero_de_servicios, :greater_than => 1
  
  def self.atributos
    ["tipo_de_paquete", "servicios_incluídos", "costo_primer_mitad_de_mes", "costo_segunda_mitad_de_mes", "costo_real_", "ahorro_"]
  end
  
  def self.traduce(atributo)
    []
  end
  
  def tipo_de_paquete
    (numero_de_servicios > 2) ? "Triple Play" : "Doble Play"
  end
  
  def servicios_incluídos
    servicios = String.new
    
    servicios += "#{internet}, " if !internet.blank?
    servicios += "#{telefonia}, " if !telefonia.blank?
    servicios += "#{television}, " if !television.blank?
    servicios.chop.chop
  end
  
  def costo_primer_mitad_de_mes
    return "$ #{costo_1_10} pesos"
  end
  
  def costo_segunda_mitad_de_mes
    return "$ #{costo_11_31} pesos"
  end
  
  def costo_real_
    return "$ #{costo_real} pesos"
  end
  
  def ahorro_
    return "$ #{ahorro} pesos"
  end
  
  
  def expose
    ["Paquete :", "#{nombre}"]
  end
  
  
end
