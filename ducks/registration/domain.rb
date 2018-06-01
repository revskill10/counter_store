require 'sequent'

class RegistrationSubmitted < Sequent::Core::Event
  attrs age: Integer, status: String, parent_id: String
end

class Registration < Sequent::Core::AggregateRoot
  def initialize(id, age, parent_id)    
    fail 'Age must be under 16 months' if age < 16
    super(id)
    apply RegistrationSubmitted, age: age, status: :submitted, parent_id: parent_id
  end
end
