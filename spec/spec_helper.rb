require 'webmock/rspec'
require_relative '../lib/all'
require 'httparty'
require 'pry'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  def read_fixture(name)
    File.read("spec/fixtures/#{name}.json")
  end
end
