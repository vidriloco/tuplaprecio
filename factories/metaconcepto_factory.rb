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