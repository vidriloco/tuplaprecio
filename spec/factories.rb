Factory.define :usuario do |u|
  u.sequence(:login) { |n| "fulanito#{n}" }
  u.nombre "Fulanito Pascual"
  u.sequence(:email) { |n| "fulanito#{n}@example.com" }
  u.password "monstruo"
  u.password_confirmation { |u| u.password }
end


