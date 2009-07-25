Factory.define :estado do |e|
  e.sequence(:nombre) { |n| "estado#{n}" }
end