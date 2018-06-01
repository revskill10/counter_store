require_relative 'domain'

class RegistrationCommand < Sequent::Core::Command
  validates_presence_of :user_id
end

class SubmitRegistration < RegistrationCommand
  attrs age: Integer, parent_id: String

  validates_presence_of :age
  validates_presence_of :parent_id
  validate :age_must_be_valid

  private

  def age_must_be_valid
    errors.add :submit_registration, 'Age must be above 16 months' if age < 16
  end
end

class AcceptRegistration < RegistrationCommand
  attrs code: String

  validates_presence_of :code
end

class RegistrationCommandHandler < Sequent::Core::BaseCommandHandler
  on SubmitRegistration do |command|
    repository.add_aggregate Registration.new(command.aggregate_id, command.age, command.parent_id)
  end

  on AcceptRegistration do |command|
    do_with_aggregate(command, Registration) do |registration| 
      registration.accept      
    end
    repository.add_aggregate Student.new(Sequent.new_uuid, command.code, command.aggregate_id)
  end
end

module RegistrationActions
  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods
    def submit_registration(params)
      command = SubmitRegistration.new(
        aggregate_id: params.uuid || Sequent.new_uuid, 
        age: params.age, 
        parent_id: params.parent_id, 
        user_id: params.user_id)
      Sequent.command_service.execute_commands command
    end

    def accept_registration(params)
      command = AcceptRegistration.new(
        user_id: params.user_id,
        aggregate_id: params.registration_id,
        code: params.code
      )
      Sequent.command_service.execute_commands command
    end
  end
end