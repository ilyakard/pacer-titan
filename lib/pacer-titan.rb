require 'pacer' unless defined? Pacer

lib_path = File.expand_path(File.join(File.dirname(__FILE__), '../lib'))
$:.unshift lib_path unless $:.any? { |path| path == lib_path }

require 'pacer-titan/version'
require Pacer::Titan::JAR
require 'pacer-titan/graph'
require 'pacer-titan/titan_query'
require 'pacer-titan/external_index_query'

module Pacer
  class << self
    def titan(path="config/inmemory.properties")      
      open = proc do
        graph = Pacer.open_graphs[path]
        unless graph
          args = [java.lang.String.java_class]
          graph = com.thinkaurelius.titan.core.TitanFactory.java_send(:open, args, path)
          Pacer.open_graphs[path] = graph
        end
        graph
      end
      
      shutdown = proc do |graph|
        graph.blueprints_graph.shutdown
        Pacer.open_graphs.delete path
      end

      Titan::Graph.new(Pacer::YamlEncoder, open, shutdown)
    end
    
    def executing_route(route)
      Rails.logger.debug "Pacer Titan executing route: #{route.description}" if defined? Rails
    end	
  end
end

