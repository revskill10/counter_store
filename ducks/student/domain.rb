require 'sequent'

class StudentCreated < Sequent::Core::Event
  attrs code: String, registration_id: String
end

class Student < Sequent::Core::AggregateRoot
  def initialize(id, code, registration_id)
    super(id)
    apply StudentCreated, code: code, registration_id: registration_id
  end
end