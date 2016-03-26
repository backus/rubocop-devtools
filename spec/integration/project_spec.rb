# encoding: utf-8
# frozen_string_literal: true

RSpec.describe 'RuboCop Project' do # rubocop:disable RSpec/DescribeClass
  describe 'default configuration file' do
    let(:cop_names) do
      root = Pathname.new(__dir__).parent.parent.expand_path

      Pathname.glob("#{root}/lib/rubocop/cop/devtools/*.rb")
        .map do |file|
          cop_name =
            file
              .basename('.rb')
              .to_s
              .gsub(/(^|_)(.)/) { Regexp.last_match(2).upcase }

          "Devtools/#{cop_name}"
        end
    end

    subject(:default_config) do
      RuboCop::ConfigLoader.load_file('config/default.yml')
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
  end
end
