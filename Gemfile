# encoding: utf-8
# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

local_gemfile = 'Gemfile.local'

if File.exist?(local_gemfile)
  eval(File.read(local_gemfile)) # rubocop:disable Lint/Eval
end
