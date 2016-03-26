# encoding: utf-8
# frozen_string_literal: true

require 'rubocop'
require 'pathname'

rubocop_path = Pathname.new(__dir__).parent.join('vendor', 'rubocop')

unless rubocop_path.exist?
  fail "Can't run specs without a local RuboCop checkout. Look in the README."
end

Dir["#{rubocop_path}/spec/support/**/*.rb"].each { |f| require f }

require 'devtools/spec_helper'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.example_status_persistence_file_path = 'spec/.rspec-state'
  config.disable_monkey_patching!
  config.warnings = true

  config.profile_examples = 10
  config.order = :random

  Kernel.srand(config.seed)
end

$LOAD_PATH.unshift(File.join(__dir__, '..', 'lib'))
$LOAD_PATH.unshift(__dir__)

require 'rubocop/devtools'
require 'rubocop/devtools/expectation'
