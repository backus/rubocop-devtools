# encoding: utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Devtools::GroupSingleLineLet do
  include ExpectViolation

  subject(:cop) { described_class.new }

  it 'adds an offense for single line lets separated by newlines' do
    expect_violation(<<-SRC, filename: 'spec/foo_spec.rb')
      RSpec.describe Foo do
        some_special_dsl_setup { asdf }

        let(:blah) do
          asdf
        end

        let(:bar) { baz  }
        let(:qux) { quux }

        let(:corge) { grault }
        ^^^^^^^^^^^^^^^^^^^^^^ Group single line `let`s together without separating newlines

        let(:garply) { waldo }
        ^^^^^^^^^^^^^^^^^^^^^^ Group single line `let`s together without separating newlines
      end
    SRC
  end

  it 'approves of grouped lets' do
    expect_violation(<<-SRC, filename: 'spec/foo_spec.rb')
      RSpec.describe Foo do
        let(:bar) { baz  }
        let(:qux) { quux }
        let(:corge) { grault }
        let(:garply) { waldo }
      end
    SRC
  end

  it 'approves of only one let' do
    expect_violation(<<-SRC, filename: 'spec/foo_spec.rb')
      RSpec.describe Foo do
        let(:bar) { baz }
      end
    SRC
  end

  it 'ignores non-spec files' do
    expect_violation(<<-SRC)
      class Foo
        let(:bar) { baz  }

        let(:qux) { quux }
      end
    SRC
  end
end
