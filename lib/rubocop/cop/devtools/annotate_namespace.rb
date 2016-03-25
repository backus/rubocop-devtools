# encoding: utf-8
# frozen_string_literal: true

module RuboCop
  module Cop
    module Devtools
      # Check that the end of a namespace is annotated with a comment
      #
      # @example
      #   # bad
      #   module Foo
      #     class Bar
      #     end
      #   end
      #
      #   # good
      #   module Foo
      #     class Bar
      #     end # Bar
      #   end # Foo
      class AnnotateNamespace < Cop
        NO_ANNOTATION  = 'The end of `%<name>s` should be annotated.'
        BAD_ANNOTATION = 'The end of `%<name>s` is incorrectly annotated with `%<comment>s`.'

        AUTOCORRECT_COMMENT = ' # %<name>s'

        def on_class(node)
          check(node)
        end

        def on_module(node)
          check(node)
        end

        def autocorrect(node)
          autocorrect_method =
            if node.instance_of?(Parser::Source::Comment)
              :fix_incorrect_annotation
            else
              :fix_missing_annotation
            end

          method(autocorrect_method).curry.call(node)
        end

        private

        # ignore :reek:UtilityFunction
        def fix_incorrect_annotation(node, corrector)
          corrector.remove(node.loc.expression)
        end

        # ignore :reek:UtilityFunction
        def fix_missing_annotation(node, corrector)
          corrector.insert_after(
            node.loc.end,
            AUTOCORRECT_COMMENT % { name: node.defined_module_name }
          )
        end

        def check(node)
          return if node.single_line?

          if (inline_comment = annotation(node))
            check_inline_comment(node, inline_comment)
          else
            add_offense(node, :end, NO_ANNOTATION % { name: node.defined_module_name })
          end
        end

        # ignore :reek:FeatureEnvy
        def check_inline_comment(node, inline_comment)
          return if inline_comment.text =~ /\A# ?#{node.defined_module_name}\z/

          add_offense(
            inline_comment,
            :expression,
            BAD_ANNOTATION % { name: node.defined_module_name, comment: inline_comment.text }
          )
        end

        def annotation(node)
          processed_source
            .ast_with_comments
            .fetch(node, [])
            .find do |comment|
              comment.loc.line.equal?(node.loc.end.line)
            end
        end
      end # AnnotateNamespace
    end # Devtools
  end # Cop
end # RuboCop
