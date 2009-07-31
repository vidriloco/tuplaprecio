class PaqueteClon < ActiveRecord::Base
  has_one   :log, :as => :recurso
end