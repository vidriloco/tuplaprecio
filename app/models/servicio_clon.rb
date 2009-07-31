class ServicioClon < ActiveRecord::Base
  has_many :concepto_clones
  has_one   :log, :as => :recurso
end