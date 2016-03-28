# encoding: utf-8
# frozen_string_literal: true

module RuboCop
  module Cop
    module Devtools
      # Avoid referencing `subject` explicitly in specs
      #
      # @example
      #   # bad
      #   RSpec.describe User do
      #     subject { described_class.new }
      #
      #     it 'is valid' do
      #       expect(subject.valid?).to be(true)
      #     end
      #   end
      #
      #   # good
      #   RSpec.describe Foo do
      #     subject(:user) { described_class.new }
      #
      #     it 'is valid' do
      #       expect(user.valid?).to be(true)
      #     end
      #   end
      #
      #   # also good
      #   RSpec.describe Foo do
      #     subject(:user) { described_class.new }
      #
      #     it { should be_valid }
      #   end
      class NamedSubject < Cop
        MSG = 'Name your test subject if you need to reference it explicitly.'
        SPEC_FILE_ENDING = '_spec.rb'

        def on_send(node)
          return unless rspec? && node.method_name.equal?(:subject)

          add_offense(node, :selector) if in_spec_block?(node)
        end

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
      end # NamedSubject
    end # Devtools
  end # Cop
end # RuboCop
