# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [ File.expand_path("dummy/db/migrate", __dir__) ]
require "rails/test_help"

# Load test helpers and fixtures
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "solid_queue/java"

require "minitest/autorun"
Dir[File.expand_path("test_helpers/**/*.rb", __dir__)].each { |f| require f }

if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_paths = [ File.expand_path("fixtures", __dir__) ]
  ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_paths.first + "/files"
  ActiveSupport::TestCase.fixtures :all
end

class ActiveSupport::TestCase
  def wait_for(timeout: 1.second, interval: 0.05)
    Timeout.timeout(timeout) do
      loop do
        break if yield
        sleep interval
      end
    end
  end
end
