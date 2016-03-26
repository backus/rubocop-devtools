# frozen_string_literal: true

module RuboCop
  module Devtools
    class Expectation
      VIOLATION_LINE_PATTERN = /\A *\^/

      VIOLATION = :violation
      SOURCE    = :line

      include Adamantium

      def initialize(string)
        @string = string
      end

      def source
        source_map.to_s
      end

      def assertions
        source_map.assertions
      end

      private

      def source_map
        tokens.reduce(Source::BLANK) do |source, (type, tokens)|
          tokens.reduce(source, :"add_#{type}")
        end
      end
      memoize :source_map

      def tokens
        string.each_line.chunk do |line|
          next SOURCE unless line =~ VIOLATION_LINE_PATTERN

          VIOLATION
        end
      end

      attr_reader :string

      class Source
        include Concord.new(:lines)

        BLANK = new([].freeze)

        def add_line(line)
          self.class.new(lines + [Line.new(text: line, number: lines.size + 1)])
        end

        def add_violation(violation)
          self.class.new([*lines[0...-1], lines.last.add_violation(violation)])
        end

        def to_s
          lines.map(&:text).join
        end

        def assertions
          lines.flat_map(&:assertions)
        end

        class Line
          DEFAULTS = { violations: [] }.freeze

          include Anima.new(:text, :number, :violations)

          def initialize(options)
            super(DEFAULTS.merge(options))
          end

          def add_violation(violation)
            with(violations: violations + [violation])
          end

          def assertions
            violations.map do |violation|
              Assertion.parse(
                text:        violation,
                line_number: number
              )
            end
          end
        end # Line
      end # Source

      class Assertion
        def self.parse(text:, line_number:)
          parser = Parser.new(text)

          new(
            message:      parser.message,
            column_range: parser.column_range,
            line_number:  line_number
          )
        end

        include Anima.new(:message, :column_range, :line_number),
                Adamantium,
                Comparable

        def <=>(other)
          to_a <=> other.to_a
        end

        protected

        def to_a
          [line_number, column_range.first, column_range.last, message]
        end

        class Parser
          COLUMN_PATTERN = /^ *(?<carets>\^\^*) (?<message>.+)$/

          include Concord.new(:text), Adamantium

          def column_range
            Range.new(*match.offset(:carets), true)
          end

          def message
            match[:message]
          end

          private

          def match
            text.match(COLUMN_PATTERN)
          end
          memoize :match
        end # Parser

        private_constant(*constants(false))
      end # Assertion
    end # Expectation
  end # Devtools
end # RuboCop
