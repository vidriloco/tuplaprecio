class Cobertura < ActiveRecord::Base
  include Compartido
  include LogMethods
  
  belongs_to :plaza
  
  validates_presence_of :nombre, :colonia, :calle
  validates_numericality_of :numero_de_nodo
  
  # Necesario para poder obtener CSVs de éste modelo
  acts_as_reportable
  
  # Atributos de éste modelo presentes al momento de desplegar instancias de éste modelo
  def self.atributos
    ["nombre", "numero_de_nodo", "colonia", "calle"]
  end
  
  # Atributos cuyos valores relativos a cada instancia de éste modelo serán traducidos a código ruby en un archivo para exportar como copia de seguridad
  def self.atributos_exportables
    [:nombre, :numero_de_nodo, :colonia, :calle]
  end
  
  # Método que genera una versión leíble para el usuario de un atributo del modelo
  def self.cambia(atributo)
    dicc = {'numero_de_nodo' => 'Número de nodo'}
    return dicc[atributo] unless dicc[atributo].nil?
    atributo.humanize
  end
end
