# encoding: utf-8
# frozen_string_literal: true

require 'rubocop'

require 'rubocop/devtools/version'
require 'rubocop/devtools/inject'
require 'rubocop/cop/devtools/mixin/rspec_only'

RuboCop::Devtools::Inject.defaults!

# cops
require 'rubocop/cop/devtools/annotate_namespace'
require 'rubocop/cop/devtools/specify_it'
require 'rubocop/cop/devtools/leading_subject'
require 'rubocop/cop/devtools/group_single_line_let'
