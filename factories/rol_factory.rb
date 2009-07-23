Factory.define :rol_administrador, :class => Rol do |r|
  r.nombre "Administrador"
end

Factory.define :rol_encargado, :class => Rol do |r|
  r.nombre "Encargado"
end 

Factory.define :rol_agente, :class => Rol do |r|
  r.nombre "Agente"
end