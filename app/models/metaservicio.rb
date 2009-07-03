class Metaservicio < ActiveRecord::Base
  include Compartido
  
  acts_as_reportable
  
  has_many :metasubservicios, :dependent => :destroy
  has_and_belongs_to_many :metaconceptos
  validates_presence_of :nombre, :message => "no puede ser vacío"
  validates_uniqueness_of :nombre
      
  def self.atributos
    ["nombre", "metaconceptos_"]
  end
  
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
