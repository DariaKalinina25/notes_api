# frozen_string_literal: true

source 'https://rubygems.org'

gem 'blueprinter', '~> 1.1', '>= 1.1.2'
gem 'bootsnap', require: false
gem 'kamal', require: false
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.0.2'
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'
gem 'thruster', require: false
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  # Code quality
  gem 'rubocop', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false

  # Testing
  gem 'factory_bot_rails', '~> 6.5'
  gem 'rspec-rails', '~> 8.0'
  gem 'shoulda-matchers', '~> 6.5'
end
