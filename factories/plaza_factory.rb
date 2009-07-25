Factory.define :plaza do |p|
  p.sequence(:nombre) { |n| "plaza#{n}" }
  p.association :estado
end