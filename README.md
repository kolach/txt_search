# TxtSearch (1st Task: Query Language Evaluator)

TxtSearch is a gem which executes the following subset of Lucene query language  (used in Solr and Elasticsearch) and correctly
evaluates and test the query.

Here are allowed parts of the query syntax:

- `AND` signifies AND operation
-  `OR` signifies OR operation
-  `-` negates a single token
-  `"` wraps a number of tokens to signify a phrase for searching
-  `*` at the end of a term signifies a wildcard query
-  `(` and `)` signify precedence

Therefore the following queries are possible:

```ruby

str = "I really like bananas, apples not so much"

TxtSearch::Search.new(query: 'bananas AND apples').test(str) #=> true
TxtSearch::Search.new(query: 'bana*').test(str) #=> true
TxtSearch::Search.new(query: '"not so much"').test(str) #=> true
TxtSearch::Search.new(query: 'bananas -apples').test(str) #=> false
TxtSearch::Search.new(query: 'bananas OR mangos').test(str) #=> true
TxtSearch::Search.new(query: '(bananas OR mangos) AND much').test(str) #=> true
TxtSearch::Search.new(query: '(bananas OR mangos) AND frozen').test(str) #=> false
```

## Installation

After checking out the repo (or downloading as ZIP), run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Using in your applications

Add this line to your application's Gemfile:

```ruby
gem 'txt_search'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install txt_search

## Basic Usage

TxtSearch::Search is a class which execute the following subset
of Lucene query language  (used in Solr and Elasticsearch) and correctly
evaluates and test the query. 

Here are allowed parts of the query syntax:


- `AND` signifies AND operation
-  `OR` signifies OR operation
-  `-` negates a single token
-  `"` wraps a number of tokens to signify a phrase for searching
-  `*` at the end of a term signifies a wildcard query
-  `(` and `)` signify precedence

Therefore the following is possible:

```ruby

str = "I really like bananas, apples not so much"

TxtSearch::Search.new(query: 'bananas AND apples').test(str) #=> true
TxtSearch::Search.new(query: 'bana*').test(str) #=> true
TxtSearch::Search.new(query: '"not so much"').test(str) #=> true
TxtSearch::Search.new(query: 'bananas -apples').test(str) #=> false
TxtSearch::Search.new(query: 'bananas OR mangos').test(str) #=> true
TxtSearch::Search.new(query: '(bananas OR mangos) AND much').test(str) #=> true
TxtSearch::Search.new(query: '(bananas OR mangos) AND frozen').test(str) #=> false
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kolach/txt_search.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

