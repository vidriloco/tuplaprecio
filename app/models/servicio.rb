class Servicio < ActiveRecord::Base
  include Compartido
  
  belongs_to :concepto
  belongs_to :categoria
  has_many :incorporados, :dependent => :destroy
  has_many :paquetes, :through => :incorporados
  has_many :especializados, :dependent => :destroy
  has_many :plazas, :through => :especializados
    
  validates_presence_of :concepto, :unless => "concepto_id.eql? 'Selecciona una categoría'", :message => "debe ir asociado con la categoría"
  
  attributes_to_serialize :detalles_, :associated => [:concepto, :categoria]
      
  def pon_concepto(concepto)
    self.concepto = concepto
  end
  
  def pon_categoria(categoria)
    self.categoria = categoria
  end
  
  def con_concepto
    self.concepto.nombre
  end
  
  def con_categoria
    self.categoria.nombre
  end
  
  def detalles_
    return "No hay detalles que mostrar" if self.detalles.blank?
    return self.detalles
  end
  
  def expose
    ["Servicio :", "#{detalles_}"]
  end
  
  def self.busca(algo)
    fragmento = "detalles LIKE ?"
    if algo.length > 1
      campo="detalles LIKE ? OR "
      campo=campo*(algo.length-1) + " #{fragmento}"
      array_condition=[campo]
      algo.each do |a|
        array_condition << "%#{a}%"
      end
      self.find(:all, :conditions => array_condition)
    else
      self.find(:all, :conditions => [fragmento, "%#{algo}%"])
    end
  end
  
end
