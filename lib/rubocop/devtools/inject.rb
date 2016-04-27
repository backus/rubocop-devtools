# encoding: utf-8
# frozen_string_literal: true

require 'yaml'

# This file is taken from rubocop-rspec's inject: https://git.io/vaQYa
module RuboCop
  module Devtools
    # Because RuboCop doesn't yet support plugins, we have to monkey patch in a
    # bit of our configuration.
    module Inject
      DEFAULT_FILE = File.expand_path(
        '../../../../config/default.yml', __FILE__
      )

      # ignore :reek:TooManyStatements because I didn't write this
      def self.defaults!
        path = File.absolute_path(DEFAULT_FILE)
        hash = ConfigLoader.__send__(:load_yaml_configuration, path)
        config = Config.new(hash, path)
        puts "configuration from #{DEFAULT_FILE}" if ConfigLoader.debug?
        config = ConfigLoader.merge_with_default(config, path)
        ConfigLoader.instance_variable_set(:@default_configuration, config)
      end
    end # Inject
  end # Devtools
end # RuboCop
