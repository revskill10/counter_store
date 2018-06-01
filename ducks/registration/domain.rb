require 'sequent'

class RegistrationEvent < Sequent::Core::Event
end

class RegistrationSubmitted < RegistrationEvent
  attrs age: Integer, status: String, parent_id: String
end

class RegistrationAccepted < RegistrationEvent
  attrs status: String
end

class Registration < Sequent::Core::AggregateRoot
  def initialize(id, age, parent_id)    
    super(id)
    apply RegistrationSubmitted, age: age, status: :submitted, parent_id: parent_id
  end

  def accept
    apply RegistrationAccepted, status: :accepted
  end
end
