# encoding: utf-8
# frozen_string_literal: true

require 'devtools'

# desc 'shallow clone rubocop into vendor directory'
task :clone_rubocop do
  sh 'git submodule update --init --depth 1 vendor/rubocop'
end

task 'metrics:coverage': [:clone_rubocop]

Devtools.init_rake_tasks
