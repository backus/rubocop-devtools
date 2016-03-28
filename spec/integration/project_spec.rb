# encoding: utf-8
# frozen_string_literal: true

RSpec.describe 'RuboCop Project' do # rubocop:disable RSpec/DescribeClass
  describe 'default configuration file' do
    subject(:default_config) do
      RuboCop::ConfigLoader.load_file('config/default.yml')
    end

    let(:project_root) { Pathname.new(__dir__).parent.parent.expand_path }

    let(:cop_names) do
      Pathname.glob("#{project_root}/lib/rubocop/cop/devtools/*.rb")
        .map do |file|
          cop_name =
            file
              .basename('.rb')
              .to_s
              .gsub(/(^|_)(.)/) { Regexp.last_match(2).upcase }

          "Devtools/#{cop_name}"
        end
    end

    it 'has configuration for all cops' do
      expect(default_config.keys.sort).to eq(cop_names.sort)
    end

    it 'has a nicely formatted description for all cops' do
      cop_names.each do |name|
        description = default_config[name]['Description']
        expect(description).not_to be_nil
        expect(description).not_to include("\n")
      end
    end

    it 'organizes spec files in spec/integration, spec/unit, and spec/support' do
      spec_directory = project_root.join('spec')

      expect(Pathname.glob(spec_directory.join('*'))).to eql([
        spec_directory.join('integration'),
        spec_directory.join('spec_helper.rb'),
        spec_directory.join('support'),
        spec_directory.join('unit')
      ])
    end
  end
end
