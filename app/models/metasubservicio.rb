class Metasubservicio < ActiveRecord::Base
  include Compartido
  belongs_to :metaservicio
  has_many :servicios, :dependent => :destroy
  
  validates_presence_of :nombre, :message => "no puede ir vacío"
  validates_presence_of :metaservicio_id, :message => "no puede ir en blanco"
  
  def self.atributos
    ["nombre", "es_un_servicio_de_tipo"]
  end
  
  def es_un_servicio_de_tipo
    metaservicio.nombre
  end
end
