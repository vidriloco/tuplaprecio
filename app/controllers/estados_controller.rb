class EstadosController < ApplicationController
  
  before_filter do |controller|
    controller.usuario_es?(:administrador)
  end
  
end
