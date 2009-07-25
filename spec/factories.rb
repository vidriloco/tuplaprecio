Factory.define :paquete do |p|
  p.costo_1_10 100
  p.costo_11_31 150
  p.costo_real 80
  p.ahorro 20
end

Factory.define :metaconcepto do |mc|
  mc.nombre "Un Metaconcepto genérico"
end

Factory.define :metaconcepto_tipo_a, :class => Metaconcepto do |mc|
  mc.nombre "Un Metaconcepto de tipo A"
  mc.tipo "A"
end

Factory.define :metaconcepto_tipo_b, :class => Metaconcepto do |mc|
  mc.nombre "Un Metaconcepto de tipo B"
  mc.tipo "B"
end

Factory.define :categoria do |c|
  c.nombre "Alguna Categoria"
end

Factory.define :concepto do |c|
  c.disponible true
  c.comentarios "algunos que puedan interesar"
  c.costo 100
  c.valor 4
end

Factory.define :administracion do |a|
  a.nivel_alto "Administrador" 
  a.nivel_medio "Encargado"
  a.nivel_bajo "Agente"
end



