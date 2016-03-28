# encoding: utf-8
# frozen_string_literal: true

module RuboCop
  module Cop
    module Devtools
      # Declare test subject before let declarations
      #
      # @example
      #   # bad
      #   RSpec.describe User do
      #     let(:params) { blah }
      #     subject { described_class.new(params) }
      #
      #     it 'is valid' do
      #       expect(subject.valid?).to be(true)
      #     end
      #   end
      #
      #   # good
      #   RSpec.describe User do
      #     subject { described_class.new(params) }
      #
      #     let(:params) { blah }
      #
      #     it 'is valid' do
      #       expect(subject.valid?).to be(true)
      #     end
      #   end
      class LeadingSubject < Cop
        include RSpecOnly

        MSG = 'Declare `subject` above any other `let` declarations'

        def on_block(node)
          return unless rspec? && subject_definition?(node)

          node.parent.each_child_node do |sibling|
            break if sibling.equal?(node)

            break add_offense(node, :expression) if sibling.method_name.equal?(:let)
          end
        end

        private

        def subject_definition?(node)
          node.method_name.equal?(:subject) && !in_spec_block?(node)
        end
      end # LeadingSubject
    end # Devtools
  end # Cop
end # RuboCop
