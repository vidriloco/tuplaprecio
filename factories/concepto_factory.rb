Factory.define :concepto_con_metaconcepto_tipo_A, :class => Concepto do |c|
  c.disponible true
  c.comentarios "algunos que puedan interesar para tipo A"
  c.costo 100
  c.association :metaconcepto, :factory => :metaconcepto_tipo_a
end

Factory.define :concepto_con_metaconcepto_tipo_B, :class => Concepto do |c|
  c.disponible false
  c.comentarios "algunos que puedan interesar para tipo B"
  c.valor 9
  c.association :metaconcepto, :factory => :metaconcepto_tipo_b
end