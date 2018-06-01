require_relative '../store'
Sequent::Support::ViewSchema.define(view_projection: Store::VIEW_PROJECTION) do
  create_table :counter_records, :force => true do |t|
    t.string :aggregate_id, :null => false
    t.integer :amount, null: false, default: 0
  end

  create_table :registration_records, :force => true do |t|
    t.string :aggregate_id, null: false
    t.integer :age, null: false
    t.string :status, null: false, default: 'submitted'
    t.string :parent_id, null: false
  end

  add_index :counter_records, ["aggregate_id"], :name => "unique_aggregate_id_for_counter", :unique => true
  add_index :registration_records, ["aggregate_id"], :name => "unique_aggregate_id_for_registration", :unique => true
end
