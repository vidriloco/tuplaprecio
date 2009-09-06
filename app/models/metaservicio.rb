class Metaservicio < ActiveRecord::Base
  include Compartido
  
  has_many :metasubservicios, :dependent => :destroy
  has_and_belongs_to_many :metaconceptos
  validates_presence_of :nombre, :message => "no puede ser vacío"
  validates_uniqueness_of :nombre
  
  # Necesario para poder obtener CSVs de éste modelo
  acts_as_reportable
      
  # Atributos de éste modelo presentes al momento de desplegar instancias de éste modelo    
  def self.atributos
    ["nombre", "metaconceptos_"]
  end
  
  # Atributos cuyos valores relativos a cada instancia de éste modelo serán traducidos a código ruby en un archivo para exportar como copia de seguridad
  def self.atributos_exportables
    [:nombre]
  end
  
  def metaconceptos_
    metaconceptos.size
  end
  
  def self.per_page
    1
  end
  
  
end
