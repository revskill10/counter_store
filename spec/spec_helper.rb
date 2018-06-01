require 'rspec'
require 'database_cleaner'
require_relative '../store'

RSpec.configure do |config|
  config.before(:suite) do
    Store.start
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end