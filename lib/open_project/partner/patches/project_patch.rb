module OpenProject
  module Partner
    module Patches
      module ProjectPatch
        def self.included(base) # :nodoc:
          base.class_eval do
            belongs_to :partner, optional: true
      
          end
        end
      end
    end
  end
end
