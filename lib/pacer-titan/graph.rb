module Pacer
  module Titan
    # hack to make indexing work:
    class FeatureProxy
      def initialize original_features 
        @features = original_features 
      end
      
      def supportsIndices
        true
      end
      
      def method_missing(name, *args, &block)
        @features.public_send(name, *args, &block) 
      end
    end
    
    class Graph < PacerGraph
      def features
        FeatureProxy.new(blueprints_graph.features)
      end 
      
      def indices
        key_indices
      end
    end
  end
end