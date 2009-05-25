class Categoria < ActiveRecord::Base
  include Compartido
  
  has_many :servicios, :dependent => :destroy
  has_and_belongs_to_many :conceptos
  validates_presence_of :nombre, :message => "no puede ser vacío"
  
  acts_as_fulltextable :nombre
  
  attributes_to_serialize :nombre, :associated => [:conceptos]
  
  def agrega_nuevo_concepto(concepto)
    self.conceptos << concepto
    self.save!
  end
  
  def self.per_page
    1
  end
  
  def expose
    ["Categoría :", "#{nombre}"]
  end
end
