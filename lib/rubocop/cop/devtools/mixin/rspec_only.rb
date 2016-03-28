# frozen_string_literal: true
module RuboCop
  module Cop
    module RSpecOnly
      SPEC_FILE_ENDING = '_spec.rb'

      private

      # ignore :reek:UtilityFunction
      def in_spec_block?(node)
        node.each_ancestor(:block).any? do |ancestor|
          %i[it specify].include?(ancestor.method_name)
        end
      end

      def rspec?
        source_filename.end_with?(SPEC_FILE_ENDING)
      end

      def source_filename
        processed_source.buffer.name
      end
    end # RSpecOnly
  end # Cop
end # RuboCop
