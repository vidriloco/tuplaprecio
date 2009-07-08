class Metaconcepto < ActiveRecord::Base
  include Compartido
  
  acts_as_reportable
  
  has_many :conceptos, :dependent => :destroy
  has_and_belongs_to_many :metaservicios
  
  validates_presence_of :nombre, :tipo, :message => "no puede ser vacío"
  
  def self.atributos
    ["nombre", "tipo", "metaservicios_"]
  end
  
  def self.atributos_exportables
    [:nombre, :tipo]
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
