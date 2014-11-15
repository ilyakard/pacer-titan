module Pacer
  module Core::Graph::VerticesRoute
    # Helper function to query a vertex-centric index
    def vertex_query(labels, direction, options={}, &block)
      options[:element_type] ||= :vertex
      limit = options.delete(:limit)
      order_by = options.delete(:order)
      
      chain_route options.merge(pipe_class: Pacer::Pipes::VertexQueryPipe,
                                pipe_args: [labels, direction, options[:element_type], block, limit, order_by], 
                                route_name: "VertexQuery (#{labels} - #{direction})")
    end
  end
  
  # Note Gremlin has a VertexQueryPipe, however it does not support Titan's orderBy for vertex-centric indexes, hence ruby implementation:
  module Pipes
    class VertexQueryPipe < RubyPipe
      
      def initialize(labels, direction, element_type, block=nil, limit=nil, order_by={})
        super()
        @labels = labels
        @block = block
        @limit = limit
        @current_iterator = nil
        @order_by = order_by.keys.first if order_by
        @order_direction = order_by.values.first if order_by
        @element_type = element_type
        
        case direction.to_sym
        when :out
          @direction = com.tinkerpop.blueprints.Direction::OUT
        when :in
          @direction = com.tinkerpop.blueprints.Direction::IN
        when :both
          @direction = com.tinkerpop.blueprints.Direction::BOTH
        else
          raise "Invalid direction to VertexQueryPipe (use :out, :in, or :both)"
        end
        
        case @order_direction.try(:to_sym)
        when :asc
          @order_direction = com.thinkaurelius.titan.core.Order::ASC
        when :desc
          @order_direction = com.thinkaurelius.titan.core.Order::DESC
        else
          @order_direction = nil
        end
      end
      
      def processNextStart
        while true
          if @current_iterator.try(:has_next)
            return @current_iterator.next
          else
            vertex = starts.next
            query = vertex.query.direction(@direction).labels(@labels)
            query = query.instance_exec(&@block) if @block
            query = query.order_by(@order_by.to_s, @order_direction) if @order_by && @order_direction
            query = query.limit(@limit) if @limit
            if @element_type == :vertex
              @current_iterator = query.vertices.iterator
            else
              @current_iterator = query.edges.iterator
            end
          end
        end
      end
    end
  end
end

