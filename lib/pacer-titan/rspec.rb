class RSpec::GraphRunner
  module Titan
    def all(usage_style = :read_write, indices = true, &block)
      super
      titan(usage_style, indices, &block)
    end

    def titan(usage_style = :read_write, indices = true, &block)
      for_graph('titan', usage_style, indices, false, titan_graph, titan_graph_2, nil, block)
    end

    protected

    def titan_graph
      return @titan_graph if @titan_graph
      @titan_graph = Pacer.titan('../pacer-titan/config/inmemory.properties')
    end

    def titan_graph_2
      return @titan_graph_2 if @titan_graph_2
      @dex_graph2 = Pacer.titan('../pacer-titan/config/inmemory.properties')
    end
  end
end
