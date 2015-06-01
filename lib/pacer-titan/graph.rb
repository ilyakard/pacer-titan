module Pacer
  module Titan
    class Graph < PacerGraph
    
      # Include label in key indices so we can limit index queries by vertex label
      def key_indices(type = nil)
        indices = super
        indices.add 'label'
      end
      
      # Use GraphQuery for index lookups, based on pacer-neo4j's code:
      private
      def indexed_route(element_type, filters, block)
        return super if search_manual_indices
        
        filters.graph = self
        filters.use_lookup!
        query = indexed_properties(element_type, filters)
        
        if query
          route = exact_query(query, element_type: element_type, extensions: filters.extensions, wrapper: filters.wrapper)
          
          filters.remove_property_keys key_indices(element_type)
          if filters.any?
            Pacer::Route.property_filter(route, filters, block)
          else
            route
          end
        elsif filters.route_modules.any?
          mod = filters.route_modules.shift
          Pacer::Route.property_filter(mod.route(self), filters, block)
        end
      end
            
      def indexed_properties(type, filters)
        filters.properties.select { |k, v| key_indices(type).include?(k) }
      end
    end
  end
end