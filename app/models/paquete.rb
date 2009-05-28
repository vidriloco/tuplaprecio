class Paquete < ActiveRecord::Base
  include Compartido
  
  has_and_belongs_to_many :plazas
  has_many :incorporados
  has_many :servicios, :through => :incorporados
  attributes_to_serialize :nombre, :associated => [:incorporados, :plazas]
  
  acts_as_ferret :fields => [:nombre]
  
  validates_presence_of :nombre, :message => "no puede ser vacío"
  
  def self.compartidas
    compartidas = Array.new
    self.find(:all).each do |paquete|
      if paquete.plazas.length > 1
        compartidas << paquete
      end
    end
    compartidas
  end
  
  def agrega_nuevo_incorporado(incorporado)
    self.incorporados << incorporado
    self.save!
  end
  
  
  def nombre_comercial
    if self.nombre.nil?
      "No Aplica" 
    else
      self.nombre
    end
  end
  
  def con_costo
    if self.costo.nil?
      "No asignado"
    else
      "$ #{self.costo} pesos"
    end
  end
  
  def concepto_de_no_combo
    unless self.servicios[0].nil?
      return self.servicios[0].con_concepto
    end
  end
  
  def categoria_de_no_combo
    unless self.servicios[0].nil?
      return self.servicios[0].con_categoria
    end
  end
  
  def listado_de_servicios_incorporados
    out=String.new
    self.incorporados.each do |incorporado|
      out+="#{ incorporado.servicio.con_concepto }<br/>"
    end
    out
  end
  
  def expose
    ["Paquete :", "#{nombre}"]
  end
end
