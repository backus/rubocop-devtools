# encoding: utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Devtools::AnnotateNamespace do
  include ExpectViolation

  subject(:cop) { described_class.new }

  it 'checks the end of a class' do
    expect_violation(<<-SRC)
      class Foo
      end
      ^^^ The end of `Foo` should be annotated.
    SRC
  end

  it 'checks the end of a module' do
    expect_violation(<<-SRC)
      class Foo
      end
      ^^^ The end of `Foo` should be annotated.
    SRC
  end

  it 'checks nested scopes' do
    expect_violation(<<-SRC)
      module Foo
        class Bar
        end
        ^^^ The end of `Bar` should be annotated.
      end
      ^^^ The end of `Foo` should be annotated.
    SRC
  end

  it 'approves correctly annotated namespaces' do
    expect_violation(<<-SRC)
      module Foo
      end # Foo
    SRC
  end

  it 'disapproves incorrectly annotated namespaces' do
    expect_violation(<<-SRC)
      # frozen_string_literal: true

      module Bar
      end # FooBar
          ^^^^^^^^ The end of `Bar` is incorrectly annotated with `# FooBar`.
    SRC
  end

  it 'does not blow up on anonymous class' do
    expect_violation(<<-SRC)
      Class.new do
      end
    SRC
  end

  it 'ignores single line classes' do
    expect_violation(<<-SRC)
      class Foo; end
    SRC
  end

  it 'auto-corrects missing comment' do
    new_source = autocorrect_source(
      cop,
      [
        'class Foo',
        'end'
      ]
    )

    expect(new_source).to eq([
      'class Foo',
      'end # Foo'
    ].join("\n"))
  end

  it 'removes wrong comment on auto-correct' do
    new_source = autocorrect_source(
      cop,
      [
        '# frozen_string_literal: true',
        '',
        '# this is my foo class',
        'class Foo',
        'end # Bar'
      ]
    )

    expect(new_source).to eq([
      '# frozen_string_literal: true',
      '',
      '# this is my foo class',
      'class Foo',
      'end '
    ].join("\n"))
  end
end
