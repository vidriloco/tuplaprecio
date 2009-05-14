class Rol < ActiveRecord::Base
  include Compartido
  
  has_many :usuarios
  
  attributes_to_serialize :nombre, :associated => [:usuarios]
end
