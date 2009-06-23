class Metaconcepto < ActiveRecord::Base
  include Compartido
  
  has_many :conceptos, :dependent => :destroy
  has_and_belongs_to_many :metaservicios
  
  validates_presence_of :nombre, :tipo, :message => "no puede ser vacío"
  
  def self.atributos
    ["nombre", "tipo", "detalles_de_tipo", "metaservicios_"]
  end
  
  def detalles_de_tipo
    if tipo.eql?("A")
      "Con campo 'costo' para introducir precios"
    elsif tipo.eql?("B")
      "Con campo 'valor' para introducir números que no son precios"
    end
  end
  
  def metaservicios_
    mservicios_nombres=metaservicios.inject("") do |cdna, mservicio|
      cdna<<"#{mservicio.nombre}, "
      cdna
    end
    return "-" if mservicios_nombres.blank?
    mservicios_nombres.chop.chop    
  end
  
end
