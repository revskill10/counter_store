class LoggerSubscriber < Sequent::Core::BaseEventHandler
  on CounterCreated do |event|
    puts "CounterCreated"
  end

  on CounterIncreased do |event|
    puts "CounterIncreased"
  end

  on CounterDecreased do |event|
    puts "CounterDecreased"
  end
end