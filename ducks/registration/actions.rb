require_relative 'domain'

class RegistrationCommand < Sequent::Core::Command
end

class SubmitRegistration < RegistrationCommand
  attrs age: Integer, parent_id: String

  validates_presence_of :age
  validates_presence_of :parent_id
end

class RegistrationCommandHandler < Sequent::Core::BaseCommandHandler
  on SubmitRegistration do |command|
    repository.add_aggregate Registration.new(command.aggregate_id, command.age, command.parent_id)
  end
end

module RegistrationActions
  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods
    def submit_registration(uuid, age, parent_id)
      command = SubmitRegistration.new(aggregate_id: uuid || Sequent.new_uuid, age: age, parent_id: parent_id)
      Sequent.command_service.execute_commands command
    end
  end
end