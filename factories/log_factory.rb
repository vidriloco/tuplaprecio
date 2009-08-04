Factory.define :log_servicio, :class => Log do |l|
  l.accion 'crear'
  l.association :recurso, :factory => :servicio
  l.association :usuario, :factory => :usuario_completo_encargado
  l.fecha_de_creacion Time.now.localtime
end

Factory.define :log_paquete, :class => Log do |l|
  l.accion 'crear'
  l.association :recurso, :factory => :paquete_doble_play
  l.association :usuario, :factory => :usuario_completo_encargado
  l.fecha_de_creacion Time.now.localtime
end