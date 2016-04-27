# encoding: utf-8
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'rubocop/devtools/version'

Gem::Specification.new do |gem|
  gem.name        = 'rubocop-devtools'
  gem.version     = RuboCop::Devtools::Version::STRING.dup
  gem.authors     = ['John Backus']
  gem.email       = %w[johncbackus@gmail.com]
  gem.description = 'Rubocop extensions for devtools'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/backus/rubocop-devtools'
  gem.license     = 'MIT'

  gem.require_paths         = %w[lib]
  gem.files                 = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables           = %w[]
  gem.test_files            = `git ls-files -- spec`.split($INPUT_RECORD_SEPARATOR)
  gem.extra_rdoc_files      = %w[README.md]
  gem.required_ruby_version = '>= 2.2'

  gem.add_runtime_dependency('ice_nine',   '~> 0.11.1')
  gem.add_runtime_dependency('adamantium', '~> 0.2.0')
  gem.add_runtime_dependency('anima',      '~> 0.3.0')
  gem.add_runtime_dependency('concord',    '~> 0.1.5')

  gem.add_development_dependency('devtools', '~> 0.1.6')
  gem.add_development_dependency('rspec', '~> 3.4')
  gem.add_development_dependency('rubocop', '~> 0.39')
  gem.add_development_dependency('rubocop-rspec', '~> 1.4')
end
