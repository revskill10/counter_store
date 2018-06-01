require_relative 'domain'

class StudentRecord < ActiveRecord::Base
end

class StudentEventHandler < Sequent::Core::BaseEventHandler
  on StudentCreated do |event|
    create_record(
      StudentRecord,
      aggregate_id: event.aggregate_id,
      code: event.code,
      registration_id: event.registration_id
    )
  end
end
