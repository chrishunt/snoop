# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snoop/version'

Gem::Specification.new do |spec|
  spec.name          = 'snoop'
  spec.version       = Snoop::VERSION
  spec.authors       = ['Chris Hunt']
  spec.email         = ['c@chrishunt.co']
  spec.description   = %q{Monitor content for changes}
  spec.summary       = %q{Monitor content for changes and be notified}
  spec.homepage      = 'https://github.com/chrishunt/snoop'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'thin'
  spec.add_development_dependency 'sinatra'

  spec.add_runtime_dependency 'httparty'
end
