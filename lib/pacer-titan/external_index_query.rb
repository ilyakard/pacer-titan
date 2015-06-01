module Pacer
  module Titan
    class Graph
      # Use Titan's indexQuery to access external indexes using a custom lucene string
      # eg. for grouped words search starting with lorem: g.index_query(:text, '(lorem*)')
      # can also pass an array of properties to hit multiple elasticsearch indices at once
      def index_query(index_name, properties, query, options = {})
        options[:element_type] ||= :vertex
        
        chain_route options.merge(
          index_name: index_name,
          query: query,
          properties: properties,
          filter: :external_index_query,
          back: self
        )
      end
    end
  end

  module Filter
    module ExternalIndexQuery
      attr_accessor :query, :properties, :top, :index_name
      
      def top_hits(n)
        self.top = n
        self
      end
      
      def count
        query_result.count
      end
        
      protected
      
      def query_result
        query_string = build_titan_lucene_query(query, properties)
        path = graph.blueprints_graph.index_query(index_name, query_string)
        path.limit(top) if top
        path = path.vertices.collect{ |v| v.get_element }
      end
      
      # expects query in the form of 'v.text:(lorem*)' to search 'text' vertex property with lucene query syntax '(lorem*)'
      def build_titan_lucene_query(term, property)
        if property.is_a? Array
          queries = []
          property.each do |prop|
            prop = "\"#{prop}\"" if prop.to_s.include?("_") # need to surround in double quotes if indexed property has an underscore
            queries.concat [ "v.#{prop}:#{term}" ] 
          end
          queries.join " OR "
        else
          property = "\"#{property}\"" if property.to_s.include?("_") 
          "v.#{property}:#{term}"
        end
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