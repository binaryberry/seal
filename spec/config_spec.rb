require 'spec_helper'

describe 'config/alphagov.yml' do
  it 'is valid YAML' do
    config = YAML.load_file('config/alphagov.yml')

    expect(config).to be_a(Hash)
  end
end
