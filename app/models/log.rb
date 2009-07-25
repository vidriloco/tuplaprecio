class Log < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :recurso, :polymorphic => true
  
  validates_presence_of :usuario, :accion, :recurso
end
