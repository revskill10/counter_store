class LoggerSubscriber < Sequent::Core::BaseEventHandler
  on CounterCreated do |event|
    puts "CounterCreated: " + event.to_json
  end

  on CounterIncreased do |event|
    puts "CounterIncreased: " + event.to_json
  end
end