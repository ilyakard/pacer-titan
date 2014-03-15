# Titan Graph Database Adapter for Pacer

[Pacer](https://github.com/pangloss/pacer) is a
[JRuby](http://jruby.org) graph traversal framework built on the
[Tinkerpop](http://www.tinkerpop.com) stack.

This is an alpha-version pacer adapter with basic support for a [Titan](http://thinkaurelius.github.io/titan) graph in Pacer.

## Installation

As always: ```gem 'pacer-titan'```, then you will need to load the jars for your storage backend of choice (see below).

If you want to hack at pacer-titan:
- You will need to install Maven first. 
- Clone this repository.
- Run ```rake install``` in its directory to build Titan's jars.
- Include the gem in your project's gemfile, directing its path to your cloned copy.

## Backends

This gem includes Titan 0.4.2 and its dependencies.

It seems embedded backends (embedded Cassandra, embedded ElasticSearch) do not launch without extra work specifying their class paths when launching your app.

The excellent [jBundler](https://github.com/mkristian/jbundler) does a great job of this for you, simply add any of the following to your Jarfile as needed:

```ruby
jar 'com.thinkaurelius.titan:titan-es', '~> 0.4.2' # ElasticSearch
jar 'com.thinkaurelius.titan:titan-cassandra', '~> 0.4.2' # Cassandra
jar 'com.thinkaurelius.titan:titan-berkeleyje', '~> 0.4.2' # BerkeleyDB
```

You may find your JRuby JVM crashes under heavy load if you include too many jars; increase your -XX:MaxPermSize

## Usage

Opening a Titan graph in Pacer:

```ruby
require 'pacer'
require 'pacer-titan'

g = Pacer.titan 'path/to/titan_config.properties'
```

The graph settings are specified in an Apache Configuration .properties file.

## Titan-specific routes

You can use Titan's [indexing predicates](https://github.com/thinkaurelius/titan/wiki/Indexing-Backend-Overview#querying-an-index) in pacer routes.
```ruby
g.query{ has('text', Text::CONTAINS, 'lorem') }.out(:author)
```
Be sure to ```import com.thinkaurelius.titan.core.attribute.Text``` for the above example.

You can also use Titan's indexQuery() method to send queries in Lucene syntax to [external indices](https://github.com/thinkaurelius/titan/wiki/Direct-Index-Query):
```ruby 
g.index_query(:text, '(lorem ipsum*)', index_name: 'search').out(:author)
```
  
The index_query route can take an array of indices as the first parameter, you can also pass an options hash as the third parameter to specify the index name if it is something other than 'search' as used in most of the Titan configuration examples.

## License
Based on Derrick Wiebe's pacer-dex and pacer-neo4j gems, as well as code by Steven McCraw and others on the pacer-users list.
This gem is released under the liberal MIT license.