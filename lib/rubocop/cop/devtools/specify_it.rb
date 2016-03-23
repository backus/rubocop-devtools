# encoding: utf-8
# frozen_string_literal: true

module RuboCop
  module Cop
    module Devtools
      # Avoid writing `it do` in specs
      #
      # @example
      #   # bad
      #   it do
      #     expect(foo).to eq(bar)
      #   end
      #
      #   # ok
      #   it { expect(foo).to eq(bar) }
      #
      #   # ok
      #   specify do
      #     expect(foo).to eq(bar)
      #   end
      class SpecifyIt < Cop
        MSG = 'Prefer either `it { ... }` or `specify do` over `it do`'

        def on_block(node)
          return unless multiline_it_without_description?(node)

          add_offense(node.children.first, :selector)
        end

        private

        # ignore :reek:FeatureEnvy :reek:UtilityFunction
        def multiline_it_without_description?(node)
          node.method_name.equal?(:it) &&
            node.multiline?            &&
            node.method_args.none?
        end
      end # SpecifyIt
    end # Devtools
  end # Cop
end # RuboCop
