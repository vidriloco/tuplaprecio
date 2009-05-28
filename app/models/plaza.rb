class Plaza < ActiveRecord::Base
  include Compartido
  
  belongs_to :estado
  has_and_belongs_to_many :paquetes, :autosave => true
  has_many :usuarios, :as => :responsabilidad, :autosave => true, :dependent => :nullify
  has_many :especializados
  has_many :servicios, :through => :especializados
  
  acts_as_ferret :fields => {:nombre => { :store => :yes }}
  
  attributes_to_serialize :nombre, :associated => [:usuarios, :paquetes, :especializados, :estado]
  
  validates_presence_of :nombre, :message => "no puede ser vacío"
  
  
  def presentaciones_que_comparto_con_plazas
    relacion_de_compartir = Hash.new
    self.presentaciones.each do |presentacion|
      lista_de_plazas = presentacion.plazas.clone
      lista_de_plazas.delete(self)
      if relacion_de_compartir[presentacion].nil?
        relacion_de_compartir[presentacion] = lista_de_plazas
      else
        relacion_de_compartir[presentacion] << lista_de_plazas
      end
    end
    relacion_de_compartir
  end
  
  def agrega_nuevo_paquete(paquete)
    self.paquetes << paquete
    self.save!
  end
  
  def agrega_nuevo_especializado(especializado)
    self.especializados << especializado
    self.save!
  end
    
  def agrega_nuevo_usuario(usuario)
    self.usuarios << usuario
    self.save!
  end
  
  def eliminar_usuario(usuario)
    self.listado_de_usuarios.delete(usuario)
  end
  
  def listado_de_usuarios
    self.usuarios
  end
  
  def expose
    ["Plaza :", "#{nombre}"]
  end
  
  #def en
  #   "" if self.estado.nil?
  #   self.estado.nombre
  # end
  
end
