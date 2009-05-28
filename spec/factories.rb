Factory.define :usuario do |u|
  u.sequence(:login) { |n| "fulanito#{n}" }
  u.nombre "Fulanito Pascual"
  u.sequence(:email) { |n| "fulanito#{n}@example.com" }
  u.password "monstruo"
  u.password_confirmation { |u| u.password }
end

Factory.define :categoria do |c|
  c.nombre "unacategoria"
  c.conceptos { |conceptos| [conceptos.association(:concepto)] }
end

Factory.define :concepto do |c|
  c.nombre "unconcepto"
end

Factory.define :estado do |e|
  e.sequence(:nombre) { |n| "estado#{n}" }
end

Factory.define :plaza do |p|
  p.sequence(:nombre) { |n| "plaza#{n}" }
  p.association :estado
end

Factory.define :rol_nivel_1, :class => Rol do |r|
  r.nombre "Administrador"
end

Factory.define :rol_nivel_2, :class => Rol do |r|
  r.nombre "Encargado"
end 

Factory.define :rol_nivel_3, :class => Rol do |r|
  r.nombre "Agente"
end

Factory.define :administracion do |a|
  a.nivel_alto "Administrador" 
  a.nivel_medio "Encargado"
  a.nivel_bajo "Agente"
end

Factory.define :usuario_completo_agente, :class => Usuario do |u|
  u.sequence(:login) { |n| "fulanito#{n}" }
  u.nombre "Fulanito Pascual"
  u.sequence(:email) { |n| "fulanito#{n}@example.com" }
  u.password "monstruo"
  u.password_confirmation { |u| u.password }
  u.association :rol, :factory => :rol_nivel_3
end

Factory.define :usuario_completo_encargado, :class => Usuario do |u|
  u.sequence(:login) { |n| "fulanito#{n}" }
  u.nombre "Fulanito Pascual"
  u.sequence(:email) { |n| "fulanito#{n}@example.com" }
  u.password "monstruo"
  u.password_confirmation { |u| u.password }
  u.association :responsabilidad, :factory => :plaza
  u.association :rol, :factory => :rol_nivel_2
end

Factory.define :usuario_completo_admin, :class => Usuario do |u|
  u.sequence(:login) { |n| "fulanito#{n}" }
  u.nombre "Fulanito Pascual"
  u.sequence(:email) { |n| "fulanito#{n}@example.com" }
  u.password "monstruo"
  u.password_confirmation { |u| u.password }
  u.association :responsabilidad, :factory => :administracion
  u.association :rol, :factory => :rol_nivel_1
end

