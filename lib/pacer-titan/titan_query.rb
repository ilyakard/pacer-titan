module Pacer
  module Titan
    class Graph
      # Use Titan's QueryBuilder to access indexes (replaces g.v(key: value) style index querying
      # eg: g.query{ has('login', 'ilya').has('description', Text::CONTAINS, 'abc') }.out(:messages)
      # be sure to java_import com.thinkaurelius.titan.core.attribute.Text for the above example
      def query(options = { element_type: :vertex }, &query)
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
      
      def query_result
        path = graph.blueprints_graph.query.instance_exec(&query)
        path.limit(top) if top
        path = path.vertices
      end
      
      def source_iterator
        query_result.to_route(element_type: :vertex, graph: graph)
      end
      
      def inspect_string
        "#{ inspect_class_name }"
      end
    end
  end
end