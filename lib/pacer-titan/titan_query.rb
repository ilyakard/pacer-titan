module Pacer
  module Titan
    class Graph
      # Use Titan's QueryBuilder to access indices when you need to specify other comparison predicates
      # eg: g.query{ has('description', Text::CONTAINS, 'abc').has('login', 'ilya') }.out(:messages)...
      # be sure to import com.thinkaurelius.titan.core.attribute.Text for the above example
      def query(options = {}, &query)
        options[:element_type] ||= :vertex
        
        chain_route options.merge(
          query: query,
          filter: :titan_query,
          back: self
        )
      end
      
      # Pass a hash of properties and values to look for in Titan's standard (exact) index
      def exact_query(query, options={})
        options[:element_type] ||= :vertex
        
        chain_route options.merge(
          query: query,
          filter: :titan_query,
          back: self
        )
      end
    end
  end

  module Filter
    module TitanQuery
      attr_accessor :query, :top
      
      def top_hits(n)
        self.top = n
        self
      end
      
      def count
        query_result.count
      end
        
      protected
      
      def build_graph_centric_vertex_query(properties = {})
        path = graph.blueprints_graph.query
        properties.each do |key, value|
          path = path.has("#{ key }", graph.encode_property(value))
        end
        path
      end
      
      def query_result
        if query.is_a?(Array) || query.is_a?(Hash)
          path = build_graph_centric_vertex_query(query)
        elsif query.kind_of? Proc
          path = graph.blueprints_graph.query.instance_exec(&query)
        else
          raise "Invalid query type for index lookup (takes a hash or block): #{ query }"
        end
        
        path.limit(top) if top
        
        if element_type == :edge
          path.edges
        else
          path.vertices
        end
      end
      
      def source_iterator
        query_result.to_route(element_type: element_type, graph: graph)
      end
      
      def inspect_string
        "#{ inspect_class_name }"
      end
    end
  end
end