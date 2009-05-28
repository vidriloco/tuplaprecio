class Especializado < ActiveRecord::Base
  include Compartido
  belongs_to :servicio
  belongs_to :plaza
  
  # Métodos ( y atributos ) que se imprimirán cada vez que se invoque el método *to_hashed_html heredado de Compartido
  attributes_to_serialize :categoria, :concepto, :detalles_del_servicio, :activo_, :costo_
  remap_names 'Especializado' => 'Servicio'
    
  validates_presence_of :costo, :message => "no puede ir vacío"
  validates_numericality_of :costo, :message => "debe ser un valor numérico"
  
  validates_presence_of :activo, :message => "debe ser 'sí' ó 'no'"
  
  # Devuelve el nombre del concepto del servicio incorporado.
  def concepto
    self.servicio.concepto.nombre
  end
  
  # Devuelve el nombre de la categoria del servicio incorporado.
  def categoria
    self.servicio.categoria.nombre
  end
  
  # Devuelve los detalles referentes al servicio independientemente al paquete
  def detalles_del_servicio
    self.servicio.detalles
  end
  
  # Método que devuelve el estado de actividad del servicio en un formato leíble
  def activo_
    if self.activo
      return "Sí"
    else
      "No"
    end
  end
  
  # Método que devuelve el costo del servicio en un formato leíble
  def costo_
    return "$ #{self.costo} pesos"
  end
  
  # Método que expone el atributo :detalles de éste modelo juntamente con el nombre del modelo
  def expose
    ["Servicio (asignado a plaza) :", "#{detalles_del_servicio} #{costo_}"]
  end
  
  def self.busca(algo)
    fragmento = "costo LIKE ?"
    if algo.length > 1
      campo="costo LIKE ? OR "
      campo=campo*(algo.length-1) + " #{fragmento}"
      array_condition=[campo]
      algo.each do |a|
        # Necesario el hacer un cast en PostgreSQL (si es un entero)
        if a.to_i != 0 && self.connection.adapter_name.eql?("PostgreSQL")
          a = "%#{a}%::INT"
          array_condition << a
        else
          array_condition << "%#{a}%"
        end
      end
      self.find(:all, :conditions => array_condition)
    else
      self.find(:all, :conditions => [fragmento, "%#{algo}%"])
    end
  end
  
end
