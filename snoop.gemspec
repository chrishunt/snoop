# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snoop/version'

Gem::Specification.new do |spec|
  spec.name          = 'snoop'
  spec.version       = Snoop::VERSION
  spec.authors       = ['Chris Hunt']
  spec.email         = ['c@chrishunt.co']
  spec.description   = %q{Snoop on content, be notified when it changes.}
  spec.summary       = %q{Snoop on content, be notified when it changes.}
  spec.homepage      = 'https://github.com/chrishunt/snoop'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'cane'
  spec.add_development_dependency 'cane-hashcheck'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'thin'
  spec.add_development_dependency 'sinatra'

  spec.add_runtime_dependency 'httparty'
  spec.add_runtime_dependency 'nokogiri'
end
