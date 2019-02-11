source 'https://rubygems.org'

ruby '2.5.3'

gem 'rails', '~> 5.1.5'

# Infra
gem 'backup'
gem 'figaro'
gem 'pg'
gem 'puma', '~> 3.7'

# Front-end
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'sass-rails', '~> 5.0'
gem 'simple_form'
gem 'slim-rails'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

# Authentication/Authorization
gem 'activerecord-session_store'
gem 'cancancan'
gem 'devise'

# Third party API
gem 'jbuilder', '~> 2.5'
gem 'zapier_ruby'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'web-console', '>= 3.3.0'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'

  gem 'rspec-rails'

  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'

  gem 'rubocop', require: false
  gem 'simplecov', require: false
end

gem 'rails_12factor', group: :production

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
