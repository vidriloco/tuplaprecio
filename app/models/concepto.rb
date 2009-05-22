class Concepto < ActiveRecord::Base
  include Compartido
  
  has_many :servicios, :dependent => :destroy
  has_and_belongs_to_many :categorias
  validates_presence_of :nombre, :message => "no puede ser vacío"

  acts_as_fulltextable :nombre

  attributes_to_serialize :nombre, :associated => [:categorias]
  
  def agrega_nueva_categoria(categoria)
    self.categorias << categoria
    self.save!
  end
  
  def self.per_page
    5
  end
  
end
