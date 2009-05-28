class Estado < ActiveRecord::Base
  include Compartido
  
  attributes_to_serialize :nombre, :associated => [:plazas]
  validates_presence_of :nombre, :message => "no puede ser vacío"
  
  acts_as_ferret :fields => [:nombre]
  
  has_many :plazas
  
  def agrega_nueva_plaza(plaza)
    unless self.plazas.exists? plaza
      self.plazas << plaza
      self.save!
    end
  end
end
