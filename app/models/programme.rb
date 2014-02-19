class Programme < ActiveRecord::Base
  has_ancestry :cache_depth => true
  
end