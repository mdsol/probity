# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'probity/version'

Gem::Specification.new do |spec|
  spec.name          = 'probity'
  spec.version       = Probity::VERSION
  spec.authors       = ['Aaron Weiner', 'Curtis White']
  spec.email         = spec.authors.map{|name|name.sub(/(.).* (.*)/,'\1\2@mdsol.com')}
  spec.summary       = %q{Rack middleware to test whether your app is producing valid json, xml, etc.}
  spec.description   = %q{Even Rails can't be trusted not to produce malformed xml sometimes. Add this Rack middleware to the stack while you run your tests and it will monitor the responses you send, infer the appropriate validations based on content type, and raise if they fail.}
  spec.homepage      = 'https://github.com/mdsol/probity'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rspec'

  spec.add_dependency 'nokogiri'

end
