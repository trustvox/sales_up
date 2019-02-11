ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'

SimpleCov.configure do
  coverage_dir File.join('.', 'tmp', 'code_analysis', 'coverage')

  minimum_coverage 60
end

SimpleCov.start 'rails' do
  add_filter '/test/'
  add_filter '/lib/'
end

require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

require 'factory_bot'
require 'shoulda/matchers'

FactoryBot.definition_file_paths = %w[spec/support/factories]
FactoryBot.reload

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.raise_errors_for_deprecations!
  config.filter_rails_from_backtrace!
  config.infer_spec_type_from_file_location!
end
