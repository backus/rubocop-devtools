# encoding: utf-8
# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Devtools::AnnotateNamespace do
  subject(:cop) { described_class.new }

  it 'checks the end of a class' do
    inspect_source(
      cop,
      [
        'class Foo',
        'end'
      ]
    )

    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line).sort).to eq([2])
    expect(cop.messages).to eq(['The end of `Foo` should be annotated.'])
  end

  it 'checks the end of a module' do
    inspect_source(
      cop, [
        'module Foo',
        'end'
      ]
    )
    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.map(&:line).sort).to eq([2])
    expect(cop.messages).to eq(['The end of `Foo` should be annotated.'])
  end

  it 'checks nested scopes' do
    inspect_source(
      cop, [
        'module Foo',
        '  class Bar',
        '  end',
        'end'
      ]
    )
    expect(cop.offenses.size).to eq(2)
    expect(cop.offenses.map(&:line).sort).to eq([3, 4])
    expect(cop.messages).to eq([
      'The end of `Bar` should be annotated.',
      'The end of `Foo` should be annotated.'
    ])
  end

  it 'approves correctly annotated namespaces' do
    inspect_source(
      cop, [
        'module Foo',
        'end # Foo'
      ]
    )
    expect(cop.offenses).to be_empty
  end

  it 'disapproves incorrectly annotated namespaces' do
    inspect_source(
      cop, [
        '# frozen_string_literal: true',
        '',
        'module Bar',
        'end # FooBar'
      ]
    )
    expect(cop.offenses.size).to eq(1)
    expect(cop.messages).to eq([
      'The end of `Bar` is incorrectly annotated with `# FooBar`.'
    ])
  end

  it 'does not blow up on anonymous class' do
    inspect_source(
      cop, [
        'Class.new do',
        'end'
      ]
    )
    expect(cop.offenses).to be_empty
  end

  it 'ignores single line classes' do
    inspect_source(cop, 'class Foo; end')
    expect(cop.offenses).to be_empty
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
