Factory.define :metaservicio do |ms|
  ms.sequence(:nombre) { |n| "algun metaservicio con numero #{n}" }
end