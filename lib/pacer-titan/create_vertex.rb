module Pacer
  module Titan
    class Graph
      # modified from Pacer - Use titan's add_vertex override to set vertex label when creating
      # Create a vertex in the graph.
      #
      # @overload create_vertex(*args)
      #   @param [extension, Hash] *args extension (Module/Class) arguments will be
      #     added to the current vertex. A Hash will be
      #     treated as element properties.
      # @overload create_vertex(id, *args)
      #   @param [element id] id the desired element id. Some graphs
      #     ignore this.
      #   @param [extension, Hash] *args extension (Module/Class) arguments will be
      #     added to the current vertex. A Hash will be
      #     treated as element properties.
      def create_vertex(*args)
        id, wrapper, modules, props = id_modules_properties(args)
        label = props.delete(:label) if props
        
        raw_vertex = creating_elements do
          if label
            blueprints_graph.addVertexWithLabel(label)
          else
            blueprints_graph.addVertex
          end
        end
        
        if wrapper
          vertex = wrapper.new graph, raw_vertex
        else
          vertex = base_vertex_wrapper.new graph, raw_vertex
        end
        if modules.any?
          vertex = vertex.add_extensions modules
        end
        props.each { |k, v| vertex[k.to_s] = v } if props
        vertex
      end
    end
  end
end