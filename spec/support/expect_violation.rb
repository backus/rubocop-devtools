# frozen_string_literal: true

module ExpectViolation
  def expect_violation(source)
    expectation = RuboCop::Devtools::Expectation.new(source)
    inspect_source(cop, expectation.source)

    offenses = cop.offenses.map(&method(:to_assertion)).sort

    expect(offenses).to eq(expectation.assertions.sort)
  end

  private

  def to_assertion(offense)
    RuboCop::Devtools::Expectation::Assertion.new(
      message:      offense.message,
      line_number:  offense.location.line,
      column_range: offense.location.column_range
    )
  end
end # ExpectViolation
