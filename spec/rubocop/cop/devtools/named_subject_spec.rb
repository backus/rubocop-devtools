# encoding: utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Devtools::NamedSubject do
  include ExpectViolation

  subject(:cop) { described_class.new }

  it 'checks it with explicit subject usage' do
    expect_violation(<<-SRC, filename: 'spec/blah/user_spec.rb')
      RSpec.describe User do
        subject { described_class.new }

        it "is valid" do
          expect(subject.valid?).to be(true)
                 ^^^^^^^ Name your test subject if you need to reference it explicitly.
        end

        specify do
          expect(subject.valid?).to be(true)
                 ^^^^^^^ Name your test subject if you need to reference it explicitly.
        end
      end
    SRC
  end

  it 'ignores subject send in non-spec' do
    expect_violation(<<-SRC, filename: 'lib/blah/some_file.rb')
      specify do
        do_something_with(subject)
      end
    SRC
  end

  it 'ignores subject when not wrapped inside a test' do
    expect_violation(<<-SRC, filename: 'spec/blah/user_spec.rb')
      def foo
        it(subject)
      end
    SRC
  end
end
