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
        include RSpecOnly

        MSG = 'Name your test subject if you need to reference it explicitly.'

        def on_send(node)
          return unless rspec? && node.method_name.equal?(:subject)

          add_offense(node, :selector) if in_spec_block?(node)
        end
      end # NamedSubject
    end # Devtools
  end # Cop
end # RuboCop
