# Pacer monkey patch
require 'pacer'
module Pacer
  PacerGraph.class_eval do
    # Key indices
    module KeyIndices
      def key_indices(type = :vertex)
        # will raise internal error if not one of :edge or :vertex
        if features.supportsKeyIndices
          memoized_key_indices(index_class(type))
        else
          []
        end
      end

      def memoized_key_indices(type)
        @memoized_keys ||= Hash.new do |hash, key_type|
          hash[key_type] = blueprints_graph.getIndexedKeys(key_type).to_set
        end
        @memoized_keys[type]
      end
    end
    include KeyIndices
  end
end
