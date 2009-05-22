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
  
  acts_as_fulltextable :detalles  
    
  def pon_concepto(concepto)
    self.concepto = concepto
  end
  
  def pon_categoria(categoria)
    self.categoria = categoria
  end
  
  def eliminar
    self.destroy
  end
  
  def con_concepto
    if self.concepto.nil?
      ""
    else
      self.concepto.nombre
    end
  end
  
  def con_categoria
    if self.categoria.nil?
      ""
    else
      self.categoria.nombre
    end
  end
  
  def detalles_
    return "" if self.detalles.nil?
    return self.detalles
  end
  
  def to_s
    ["Servicio :", "#{detalles_}"]
  end
  
end
