# Probity

Even Rails can't be trusted not to produce malformed xml sometimes. Add this Rack middleware to the stack while you run your tests and it will monitor the responses you send, infer the appropriate validations based on content type, and raise if they fail.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'probity', git: 'git@github.com:mdsol/probity.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install probity

## Usage

Probity should only be included in your middleware stack when running in test/development mode. If you're using a conventional Rails app, for example, you could include it like so:

```ruby
# in config/environments/test.rb
config.middleware.use(Probity::ResponseValidatorMiddleware)
```

By default, Probity will validate the `application/xml` and `application/json` content types, and **raise** if it sees anything else. If you're serving something other than those two, such as html, you'll probably want to do

```ruby
middleware.use(Probity::ResponseValidatorMiddleware, missing_validator: :warn)
#or
middleware.use(Probity::ResponseValidatorMiddleware, missing_validator: :ignore)
```

You can add validators for your content types with code like this:

```ruby
Probity.validators['application/hal+json'] = Proc.new do |body|
	raise unless Halidator.new(body).valid?
end
```
You can also override the default validators the same way:

```ruby
Probity.validators['application/xml'] = # Object That Responds To .call(str)
```

## Validators

The XML validator uses [Nokogiri](http://www.nokogiri.org/) in Strict Mode, while the JSON validator uses Ruby's built-in `JSON.parse`. Pull requests are welcome for more content types. 

## Contributing

1. Fork it ( https://github.com/[my-github-username]/probity/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
