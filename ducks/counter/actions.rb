require_relative 'domain'

class CreateCounter < Sequent::Core::Command
end

class IncreaseCounter < Sequent::Core::Command
  attrs amount: Integer
end

class DecreaseCounter < Sequent::Core::Command
  attrs amount: Integer
end

class CounterCommandHandler < Sequent::Core::BaseCommandHandler
  on CreateCounter do |command|
    repository.add_aggregate Counter.new(command.aggregate_id)
  end

  on IncreaseCounter do |command|
    do_with_aggregate(command, Counter) do |counter|
      counter.increase(command.amount)
    end
  end

  on DecreaseCounter do |command|
    do_with_aggregate(command, Counter) do |counter|
      counter.decrease(command.amount)
    end
  end  
end

module CounterActions
  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods
    def create_counter(uuid)
      command = CreateCounter.new(aggregate_id: uuid || Sequent.new_uuid)
      Sequent.command_service.execute_commands command
    end

    def increase_counter(aggregate_id, amount = 0)
      command = IncreaseCounter.new(aggregate_id: aggregate_id, amount: amount)
      Sequent.command_service.execute_commands command
    end

    def decrease_counter(aggregate_id, amount = 0)
      command = DecreaseCounter.new(aggregate_id: aggregate_id, amount: amount)
      Sequent.command_service.execute_commands command
    end
  end
end
