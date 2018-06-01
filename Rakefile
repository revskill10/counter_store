require "bundler"
Bundler.setup

def current_env
  ENV["RACK_ENV"] ||= "development"
end


begin
  require 'sequent/rake/tasks'
  require_relative 'store'
  Sequent::Rake::Tasks.new({
    db_config_supplier: Store::DB_CONFIG,
    view_projection: Store::VIEW_PROJECTION,
    event_store_schema: 'public',
    environment: ENV['RACK_ENV'] || 'development'
  }).register!
rescue LoadError
  puts 'Sequent tasks are not available'
end
