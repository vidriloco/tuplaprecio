Factory.define :usuario do |u|
  u.sequence(:login) { |n| "fulanito#{n}" }
  u.nombre "Fulanito Pascual"
  u.sequence(:email) { |n| "fulanito#{n}@example.com" }
  u.password "monstruo"
  u.password_confirmation { |u| u.password }
end

Factory.define :usuario_completo_agente, :class => Usuario do |u|
  u.sequence(:login) { |n| "fulanito#{n}" }
  u.nombre "Fulanito Pascual"
  u.sequence(:email) { |n| "fulanito#{n}@example.com" }
  u.password "monstruo"
  u.password_confirmation { |u| u.password }
  u.association :rol, :factory => :rol_agente
end

Factory.define :usuario_completo_encargado, :class => Usuario do |u|
  u.sequence(:login) { |n| "fulanito#{n}" }
  u.nombre "Fulanito Pascual"
  u.sequence(:email) { |n| "fulanito#{n}@example.com" }
  u.password "monstruo"
  u.password_confirmation { |u| u.password }
  u.association :responsabilidad, :factory => :plaza
  u.association :rol, :factory => :rol_encargado
end

Factory.define :usuario_completo_admin, :class => Usuario do |u|
  u.sequence(:login) { |n| "fulanito#{n}" }
  u.nombre "Fulanito Pascual"
  u.sequence(:email) { |n| "fulanito#{n}@example.com" }
  u.password "monstruo"
  u.password_confirmation { |u| u.password }
  u.association :responsabilidad, :factory => :administracion
  u.association :rol, :factory => :rol_administrador
end