Factory.define :paquete_doble_play, :class => :paquete do |p|
  p.costo_1_10 100
  p.costo_11_31 150
  p.costo_real 80
  p.ahorro 20
  p.numero_de_servicios 2
  p.internet  "512 KBPS"
  p.telefonia "Telefonia Plus"
  p.association :plaza
  p.association :zona
end

Factory.define :paquete_triple_play, :class => :paquete do |p|
  p.costo_1_10 400
  p.costo_11_31 450
  p.costo_real 450
  p.ahorro 50
  p.numero_de_servicios 3
  p.internet  "512 KBPS"
  p.telefonia "Telefonia PlusPlus"
  p.television "Fox Channel"
  p.association :plaza
  p.association :zona
end