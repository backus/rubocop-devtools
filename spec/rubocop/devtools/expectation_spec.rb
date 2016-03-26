# frozen_string_literal: true

RSpec.describe RuboCop::Devtools::Expectation do
  subject(:expectation) { described_class.new(string) }

  context 'when given a single assertion on class end' do
    let(:string) do
      <<SRC
class Foo
end
^^^ The end of `Foo` should be annotated.
SRC
    end

    let(:assertion) { expectation.assertions.first }

    it 'has one assertion' do
      expect(expectation.assertions.size).to be(1)
    end

    it 'has an assertion on line 2' do
      expect(assertion.line_number).to be(2)
    end

    it 'has an assertion on column range 1-3' do
      expect(assertion.column_range).to eql(0...3)
    end

    it 'has an assertion with correct violation message' do
      expect(assertion.message).to eql('The end of `Foo` should be annotated.')
    end

    it 'recreates source' do
      expect(expectation.source).to eql("class Foo\nend\n")
    end
  end

  context 'when given many assertions on two lines' do
    let(:string) do
      <<SRC
foo bar
    ^ Charlie
   ^^ Charlie
    ^^ Bronco
    ^^ Alpha
baz
^ Delta
SRC
    end

    let(:assertions) { expectation.assertions.sort }

    it 'has two assertions' do
      expect(expectation.assertions.size).to be(5)
    end

    it 'has assertions on lines 1 and 2' do
      expect(assertions.map(&:line_number)).to eql([
        1,
        1,
        1,
        1,
        2
      ])
    end

    it 'has assertions on column range 1-3' do
      expect(assertions.map(&:column_range)).to eql([
        3...5,
        4...5,
        4...6,
        4...6,
        0...1
      ])
    end

    it 'has an assertion with correct violation message' do
      expect(assertions.map(&:message)).to eql(%w[
        Charlie
        Charlie
        Alpha
        Bronco
        Delta
      ])
    end

    it 'recreates source' do
      expect(expectation.source).to eql("foo bar\nbaz\n")
    end
  end
end
