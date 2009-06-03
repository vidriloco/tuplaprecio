class Concepto < ActiveRecord::Base
  include Compartido
  
  has_many :servicios, :dependent => :destroy
  has_and_belongs_to_many :categorias
  validates_presence_of :nombre, :message => "no puede ser vacío"

  attributes_to_serialize :nombre, :associated => [:categorias]
  
  def self.per_page
    5
  end
  
  def expose
    ["Concepto :", "#{nombre}"]
  end
  
end
