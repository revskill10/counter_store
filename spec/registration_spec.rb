require_relative 'spec_helper'
require 'ostruct'

RSpec.describe 'Testing Registration' do 
  def params(age, user_id = Store.new_uuid)
    OpenStruct.new(
      user_id: Store.new_uuid,
      parent_id: Store.new_uuid,
      registration_id: Store.new_uuid,
      age: age
    )
  end
  # ROLE: parent
  it 'khong cho tao duoi 16 thang tuoi' do
    expect {
      Store.submit_registration(params(15))  
    }.to raise_error(Sequent::Core::CommandNotValid)
  end

  it 'cho tao tren 16 thang tuoi' do
    par = params(17)
    Store.submit_registration(par)
    expect(Store.registration_record.last.age).to eql(par.age)
    expect(Store.registration_record.last.status.to_sym).to eql(:submitted)
    expect(Store.command_record.last.user_id).to eql(par.user_id)
  end

  xit 'requires first_name, last_name, birthdate, sex' do
    #todo
  end

  # ROLE: staff
  it 'accept submitted registration' do
    Store.submit_registration(params(17))
    staff_params = OpenStruct.new(
      user_id: Store.new_uuid,
      registration_id: Store.registration_record.last.aggregate_id,
      code: 'ABCDE'
    )
    Store.accept_registration(staff_params)
    expect(Store.registration_record.last.status.to_sym).to eql(:accepted)
    expect(Store.command_record.last.user_id).to eql(staff_params.user_id)    
    expect(Store.student_record.last.registration_id).to eql(staff_params.registration_id)
    expect(Store.student_record.last.code).to eql(staff_params.code)
    expect(Store.event_record.pluck(:event_type)).to eql(["RegistrationSubmitted", "RegistrationAccepted", "StudentCreated"])
  end
end

