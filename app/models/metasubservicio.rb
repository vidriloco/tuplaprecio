class Metasubservicio < ActiveRecord::Base
  include Compartido
  
  belongs_to :metaservicio
  has_many :servicios, :dependent => :destroy
  
  validates_presence_of :nombre, :message => "no puede ir vacío"
  validates_presence_of :metaservicio_id, :message => "no puede ir en blanco"
  
  # Necesario para poder obtener CSVs de éste modelo
  acts_as_reportable
  
  # Atributos de éste modelo presentes al momento de desplegar instancias de éste modelo
  def self.atributos
    ["nombre", "es_un_servicio_de_tipo"]
  end
  
  # Atributos cuyos valores relativos a cada instancia de éste modelo serán traducidos a código ruby en un archivo para exportar como copia de seguridad
  def self.atributos_exportables
    [:nombre]
  end
  
  def es_un_servicio_de_tipo
    metaservicio.nombre
  end
end
