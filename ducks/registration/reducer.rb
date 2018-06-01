require_relative 'domain'

class RegistrationRecord < ActiveRecord::Base
end

class RegistrationEventHandler < Sequent::Core::BaseEventHandler
  on RegistrationSubmitted do |event|
    create_record(
      RegistrationRecord,
      aggregate_id: event.aggregate_id,
      age: event.age,
      parent_id: event.parent_id
    )
  end
end
