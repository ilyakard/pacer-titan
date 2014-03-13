# Titan Graph Database Adapter for Pacer

[Pacer](https://github.com/pangloss/pacer) is a
[JRuby](http://jruby.org) graph traversal framework built on the
[Tinkerpop](http://www.tinkerpop.com) stack.

Based on Derrick's pacer-dex gem

This is an alpha-version plugin with basic support for a [Titan](http://sparsity-technologies.com) Cassandra graph in Pacer.


## Usage

Here is how you open a Dex graph in Pacer.

  require 'pacer'
  require 'pacer-dex'

  # Graph will be created if it doesn't exist
  graph = Pacer.dex 'path/to/graph'

All other operations are identical across graph implementations (except
where certain features are not supported). See Pacer's documentation for
more information.

