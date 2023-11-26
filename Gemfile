source "https://rubygems.org"

ruby "3.2.2"

# Load environment variables from .env for Rails applications [https://github.com/bkeepers/dotenv]
gem "dotenv-rails", require: "dotenv/rails-now"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.2"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors", "~> 2.0", ">= 2.0.1"

# Authentication solution for Rails with Warden [https://github.com/heartcombo/devise]
gem "devise", "~> 4.9"

# JWT token authentication for Devise [https://github.com/waiting-for-dev/devise-jwt]
gem "devise-jwt", "~> 0.11.0"

# Framework for building REST-like APIs in Ruby [https://github.com/ruby-grape/grape]
gem "grape", "~> 2.0"

# Model and other object representations for API endpoints in Grape [https://github.com/ruby-grape/grape-entity]
gem "grape-entity", "~> 1.0"

# Object-oriented authorization for Rails applications [https://github.com/varvet/pundit]
gem "pundit", "~> 2.3"

# Soft-deletes for ActiveRecord models [https://github.com/rubysherpas/paranoia]
gem "paranoia", "~> 2.6"

#
gem "aasm", "~> 5.5"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows]
  # Testing framework for Rails [https://github.com/rspec/rspec-rails]
  gem "rspec-rails"
  # Simplifies creating complex factory objects in tests [https://github.com/thoughtbot/factory_bot_rails]
  gem "factory_bot_rails"
  # Generate fake data for tests and seeds [https://github.com/faker-ruby/faker]
  gem "faker"
  # Provides simple one-liner tests for common Rails functionalities [https://github.com/thoughtbot/shoulda-matchers]
  gem "shoulda-matchers", "~> 5.3"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  # Enforce coding style guidelines with a Ruby style guide linter [https://github.com/testdouble/standard]
  gem "standard", "~> 1.32"
end

gem "after_commit_everywhere", "~> 1.3"
