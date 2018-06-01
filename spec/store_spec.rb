require_relative 'spec_helper'

RSpec.describe 'Testing Counter' do 
  it 'raises error if increases with negative amount' do
    aggregate_id = Store.new_uuid
    expect {
      Store.create_counter(aggregate_id)
    }.to output("CounterCreated\n").to_stdout
    expect {
      Store.increase_counter(aggregate_id, -3)
    }.to raise_error('Amount must be positive')
  end

  it 'raises error if decreases with negative amount' do
    aggregate_id = Store.new_uuid
    expect {
      Store.create_counter(aggregate_id)
    }.to output("CounterCreated\n").to_stdout
    expect {
      Store.decrease_counter(aggregate_id, -3)
    }.to raise_error('Amount must be positive')
  end

  it 'creates counter' do
    aggregate_id = Store.new_uuid
    expect {
      Store.create_counter(aggregate_id)
    }.to output("CounterCreated\n").to_stdout
    expect(Store.counter_record.last.aggregate_id).to eql(aggregate_id)  
  end

  it 'increases counter with positive amount' do
    aggregate_id = Store.new_uuid
    expect {
      Store.create_counter(aggregate_id)
      Store.increase_counter(aggregate_id, 3)  
      Store.increase_counter(aggregate_id, 4)
      Store.decrease_counter(aggregate_id, 5)
    }.to output("CounterCreated\nCounterIncreased\nCounterIncreased\nCounterDecreased\n").to_stdout
    
    expect(Store.counter_record.find_by(aggregate_id: aggregate_id).amount).to eql(2)
  end

  it 'decreases counter with positive amount' do
    aggregate_id = Sequent.new_uuid
    expect {
      Store.create_counter(aggregate_id)
      Store.decrease_counter(aggregate_id, 3)  
    }.to output("CounterCreated\nCounterDecreased\n").to_stdout
    
    expect(Store.counter_record.find_by(aggregate_id: aggregate_id).amount).to eql(-3)
  end
end
