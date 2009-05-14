module Shared
  def crea_usuario_relacionado_a(string, args={})
    related_obj=string.constantize.new args 
    u=Usuario.new :login=>"juanelo", :name => "Juan", :password => "pagoda", :password_confirmation => "pagoda", :email => "juanelo@example.com"
    u.save!
    related_obj.agrega_nuevo_usuario u
    return u,related_obj
  end
  
  def cambia_controller
    @controller = SesionesController.new
    post :create, :login => 'juanelo', :password => 'pagoda'
    @controller = AdministracionesController.new
  end
  
end