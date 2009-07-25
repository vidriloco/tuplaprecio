Factory.define :metasubservicio do |mss|
  mss.nombre "Algún Metasubservicio"
  mss.association :metaservicio
end