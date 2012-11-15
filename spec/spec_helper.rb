require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
require 'capybara/rspec'

require 'active_support/ordered_hash' if RUBY_VERSION < '1.9'

require File.expand_path(File.join(File.dirname(__FILE__), '../lib/bootstrap_forms'))

require 'support/shared_context'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include RSpec::Rails::ViewExampleGroup, :type => :view
end

Rails.backtrace_cleaner.remove_silencers!
