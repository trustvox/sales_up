ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require File.expand_path('../config/environment', __dir__)

abort("You're running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'simplecov'
require 'shoulda/matchers'

SimpleCov.start('rails') do
  coverage_dir Rails.root.join('tmp', 'coverage')
  # minimum_coverage 100
end

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods

  Shoulda::Matchers.configure do |shoulda|
    shoulda.integrate do |with|
      with.test_framework :rspec
    end
  end
end
