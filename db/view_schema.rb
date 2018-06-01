require_relative '../store'
Sequent::Support::ViewSchema.define(view_projection: Store::VIEW_PROJECTION) do
  create_table :counter_records, :force => true do |t|
    t.string :aggregate_id, :null => false
    t.integer :amount, null: false, default: 0
  end

  add_index :counter_records, ["aggregate_id"], :name => "unique_aggregate_id_for_counter", :unique => true
end
