require_relative 'domain'

class CounterRecord < ActiveRecord::Base
end

class CounterRecordEventHandler < Sequent::Core::BaseEventHandler
  on CounterCreated do |event|
    create_record(
      CounterRecord,
      aggregate_id: event.aggregate_id,
      amount: 0
    )
  end

  on CounterIncreased do |event|
    update_record(CounterRecord, event) do |counter_record|
      counter_record.amount += event.amount
    end
  end

  on CounterDecreased do |event|
    update_record(CounterRecord, event) do |counter_record|
      counter_record.amount -= event.amount
    end
  end
end

