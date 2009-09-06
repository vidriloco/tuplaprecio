class CoberturaClon < ActiveRecord::Base
  
  has_one   :log, :as => :recurso
  
end