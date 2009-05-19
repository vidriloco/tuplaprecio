class Rol < ActiveRecord::Base
  include Compartido
  
  has_many :usuarios
  
  attributes_to_serialize :nombre, :associated => [:usuarios]
  
  validates_presence_of :nombre, :message => "no puede ser vacío"
  
end
