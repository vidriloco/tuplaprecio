Factory.define :metasubservicio do |mss|
  mss.sequence(:nombre) { |n| "algun metasubservicio con numero #{n}" }
  mss.association :metaservicio
end