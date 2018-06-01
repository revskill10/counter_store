require 'sequent'

class CounterEvent < Sequent::Core::Event
end

class CounterCreated < CounterEvent
end

class CounterIncreased < CounterEvent
  attrs amount: Integer
end

class CounterDecreased < CounterEvent
  attrs amount: Integer
end

class Counter < Sequent::Core::AggregateRoot
  attr_reader :amount 

  def initialize(id)
    super(id)
    apply CounterCreated
  end

  def increase(amount = 0)
    fail 'Amount must be positive' if amount < 0
    apply CounterIncreased, amount: amount
  end

  def decrease(amount = 0)
    fail 'Amount must be positive' if amount < 0
    apply CounterDecreased, amount: amount
  end
end