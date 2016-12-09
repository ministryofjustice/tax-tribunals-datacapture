require 'webmock/rspec'

ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.minimum_coverage 100
# SimpleCov conflicts with mutant. This lets us turn it off, when necessary.
unless ENV['NOCOVERAGE']
  SimpleCov.start do
    add_filter '.bundle'
    add_filter 'spec/support'
  end
end

Dir['./spec/support/**/*.rb'].each {|f| require f}

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

=begin
  config.filter_run_when_matching :focus

  config.example_status_persistence_file_path = "spec/examples.txt"

  config.disable_monkey_patching!

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed
=end
end
