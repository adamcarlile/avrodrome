# Avrodrome

Avrodrome, just like an aerodrome is a place to store aircraft, avrodrome is a place to store Avro schemas. Designed to be use as an in memory drop in replacement for `AvroTurf/Avromatic` registry, instead of using `Webmock` and stubbing calls for testing. It can also be used in development, as it will behave exactly like talking to an Avro schema registry

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'avrodrome'
```

And then execute:

	$ bundle

Or install it yourself as:

	$ gem install avrodrome

## Configuration

```ruby
Avrodrome.configure do |config|
	config.logger = Logger.new(STDOUT) #Default
end
```

## Usage

Designed to be used as a replacement for the registry class in `AvroTurf/Avromatic`

```ruby
require 'avrodrome'

Avromatic.configure do |config|
	config.schema_store = Avro::Builder::SchemaStore.new(path: 'path/to/store')
	config.schema_registry = Avrodrome.build_adaptor
	config.build_messaging!
end
```

or

```ruby
avro = AvroTurf::Messaging.new(registry: Avrodrome.build_adaptor)
avro.encode({...})
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adamcarlile/avrodrome.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
