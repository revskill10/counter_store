require 'sequent'
require 'sequent/support'
require 'erb'
require_relative 'ducks/counter/actions'
require_relative 'ducks/counter/reducer'
require_relative 'subscribers/logger_subscriber'

Sequent.configure do |config|
  config.command_handlers = [CounterCommandHandler.new]
  config.command_filters = []
  config.event_handlers = [CounterRecordEventHandler.new, LoggerSubscriber.new]
  config.transaction_provider = Sequent::Core::Transactions::ActiveRecordTransactionProvider.new
end

module Store
  include CounterActions

  VERSION = 5

  VIEW_PROJECTION = Sequent::Support::ViewProjection.new(
    name: "view",
    version: VERSION,
    definition: "db/view_schema.rb",
    event_handlers: [
    #  CounterRecordEventHandler.new
    ]
  )
  DB_CONFIG = YAML.load(ERB.new(File.read('db/database.yml')).result)

  def self.new_uuid
    Sequent.new_uuid
  end

  def self.counter_record
    CounterRecord
  end

  def self.start
    Sequent::Support::Database.establish_connection(DB_CONFIG[ENV["RACK_ENV"]])
  end

  def self.event_handlers
    Sequent.configuration.event_handlers
  end
end


