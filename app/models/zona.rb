class Zona < ActiveRecord::Base
  include Compartido
  
  has_many :paquetes
  
  validates_presence_of :nombre, :message => "no puede ser vacío"
  
  # Necesario para poder obtener CSVs de éste modelo
  acts_as_reportable
  
  def self.atributos
    ["nombre", "paquetes_"]
  end
  
  def self.atributos_exportables
    [:nombre]
  end
  
  def paquetes_
    if paquetes.size == 1
      "1 paquete"
    else
      "#{paquetes.size} paquetes"
    end
  end
  
end
