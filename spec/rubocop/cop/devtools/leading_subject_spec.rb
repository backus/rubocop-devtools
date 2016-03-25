# encoding: utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Devtools::LeadingSubject do
  include ExpectViolation

  subject(:cop) { described_class.new }

  it 'checks subject below let' do
    expect_violation(<<-SRC, filename: 'spec/blah/user_spec.rb')
      RSpec.describe User do
        let(:params) { foo }

        subject { described_class.new }
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Declare `subject` above any other `let` declarations
      end
    SRC
  end

  it 'approves of subject above let' do
    expect_violation(<<-SRC, filename: 'spec/blah/user_spec.rb')
      RSpec.describe User do
        context 'blah' do
        end

        subject { described_class.new }

        let(:params) { foo }
      end
    SRC
  end

  it 'handles subjects in contexts' do
    expect_violation(<<-SRC, filename: 'spec/blah/user_spec.rb')
      RSpec.describe User do
        let(:params) { foo }

        context "when something happens" do
          subject { described_class.new }
        end
      end
    SRC
  end

  it 'ignores non-spec files' do
    expect_violation(<<-SRC, filename: 'lib/thing.rb')
      class Thing
        let(:hello)

        subject { hi }
      end
    SRC
  end

  it 'handles subjects in tests' do
    expect_violation(<<-SRC, filename: 'spec/blah/user_spec.rb')
      RSpec.describe User do
        # This shouldn't really ever happen in a sane codebase but I still
        # want to avoid false positives
        it "doesn't mind me calling a method called subject in the test" do
          let(foo)
          subject { bar }
        end
      end
    SRC
  end
end
