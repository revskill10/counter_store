require_relative 'spec_helper'

RSpec.describe 'Testing Registration' do 
  it 'khong cho tao duoi 16 thang tuoi' do
    parent_id = Store.new_uuid
    registration_id = Store.new_uuid
    expect {
      Store.submit_registration(registration_id, 15, parent_id)  
    }.to raise_error('Age must be under 16 months')
  end

  it 'cho tao tren 16 thang tuoi' do
    parent_id = Store.new_uuid
    registration_id = Store.new_uuid
    Store.submit_registration(registration_id, 17, parent_id)
    expect(Store.registration_record.last.age).to eql(17)
    expect(Store.registration_record.last.status.to_sym).to eql(:submitted)
  end
end
