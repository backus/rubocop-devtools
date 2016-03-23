# encoding: utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Devtools::SpecifyIt do
  include ExpectViolation

  subject(:cop) { described_class.new }

  it 'checks multiline `it`' do
    expect_violation(<<-SRC)
      it do
      ^^ Prefer either `it { ... }` or `specify do` over `it do`
        expect(1).to be(1)
      end
    SRC
  end

  it 'approves of single line `it`' do
    expect_violation('it { expect(1).to be(1) }')
  end

  it 'approves of multiline `it` with description' do
    expect_violation(<<-SRC)
      it "should be 1" do
        expect(1).to be(1)
      end
    SRC
  end

  it 'approves of multiline `specify`' do
    expect_violation(<<-SRC)
      specify do
        expect(1).to be(1)
      end
    SRC
  end
end
