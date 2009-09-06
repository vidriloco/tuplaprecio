class Metaconcepto < ActiveRecord::Base
  include Compartido
  
  has_many :conceptos, :dependent => :destroy
  has_and_belongs_to_many :metaservicios
  
  validates_presence_of :nombre, :tipo, :message => "no puede ser vacío"
  
  # Necesario para poder obtener CSVs de éste modelo
  acts_as_reportable
  
  # Atributos de éste modelo presentes al momento de desplegar instancias de éste modelo
  def self.atributos
    ["nombre", "tipo", "metaservicios_"]
  end
  
  # Atributos cuyos valores relativos a cada instancia de éste modelo serán traducidos a código ruby en un archivo para exportar como copia de seguridad
  def self.atributos_exportables
    [:nombre, :tipo]
  end
  
  def metaservicios_
    return "-" if metaservicios.blank?
    @mregreso=metaservicios.inject([]) do |mem, met|
      mem << "#{met.nombre} "
    end
    @mregreso
  end
  
  def posicion_
    return posicion unless posicion.nil?
    "Sin posición"
  end
  
end
