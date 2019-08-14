# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name          = 'jekyll-theme-isotc211-helpers'
  s.version       = '0.4.9'
  s.authors       = ['Ribose Inc.']
  s.email         = ['open.source@ribose.com']

  s.summary       = 'Helpers for the ISO/TC 211 Jekyll theme'
  s.homepage      = 'https://github.com/riboseinc/jekyll-theme-isotc211-helpers/'
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r!^(test|spec|features)/!) }

  s.add_runtime_dependency 'jekyll', '~> 3.8'
  s.add_development_dependency 'rake', '~> 12.0'
  s.add_development_dependency 'rubocop', '~> 0.50'

  s.require_paths = ["lib"]
end
