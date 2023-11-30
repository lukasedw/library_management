require "simplecov"

SimpleCov.start do
  load_profile "test_frameworks"

  add_filter %r{^/config/}
  add_filter %r{^/db/}
  add_filter "app/controllers"
  add_filter "app/channels"
  add_filter "app/mailers"
  add_filter "app/jobs"
  add_filter "app/helpers"

  add_group "API", "app/api"
  add_group "Policies", "app/policies"
  add_group "Models", "app/models"
  add_group "Services", "app/services"
  add_group "Libraries", "lib/"

  track_files "{app,lib}/**/*.rb"
end

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"

Dir[Rails.root.join("spec", "support", "**", "*.rb")].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # FactoryBot
  config.include FactoryBot::Syntax::Methods

  # Include API
  config.include RSpec::Rails::RequestExampleGroup, type: :request, file_path: /spec\/api/

  # Clear Faker uniques
  config.after(:each) do
    Faker::UniqueGenerator.clear
  end

  # Helpers
  config.include RequestHelpers, type: :request
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
