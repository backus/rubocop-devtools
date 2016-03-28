# encoding: utf-8
# frozen_string_literal: true

module RuboCop
  module Cop
    module Devtools
      # Group single line `let`s together in specs
      #
      # @example
      #   # bad
      #   RSpec.describe User do
      #     let(:params) { blah }
      #
      #     let(:something) { else }
      #
      #     before do
      #       blah
      #     end
      #
      #     let(:one_more) { thing }
      #   end
      #
      #   # good
      #   RSpec.describe User do
      #     let(:params) { blah }
      #     let(:something) { else }
      #     let(:one_more) { thing }
      #
      #     before do
      #       blah
      #     end
      #   end
      class GroupSingleLineLet < Cop
        include RSpecOnly

        MSG = 'Group single line `let`s together without separating newlines'

        def on_block(node)
          return unless rspec? && single_line_let_definition?(node)

          lets = single_line_sibling_lets(node)

          return if node.equal?(lets.first)

          above = preceding_let(lets, node)

          add_offense(node, :expression) unless above.loc.line.equal?(node.loc.line - 1)
        end

        private

        # disable :reek:UtilityFunction
        def preceding_let(lets, node)
          above, = lets.each_cons(2).find { |_above, below| below.eql?(node) }

          above
        end

        def single_line_sibling_lets(node)
          node
            .parent
            .each_child_node
            .select(&method(:single_line_let_definition?))
        end

        # disable :reek:UtilityFunction
        def single_line_let_definition?(node)
          node.method_name.equal?(:let) && node.single_line?
        end
      end # GroupSingleLineLet
    end # Devtools
  end # Cop
end # RuboCop
