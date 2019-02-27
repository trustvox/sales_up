class CreateDeal < ActiveRecord::Migration[5.1]
  def change
    create_table :deals do |t|
      t.integer :day,         null: false, default: 1
      t.string  :client_name, null: false, default: ''
      t.decimal :value,       null: false, default: 0

      t.timestamps
    end

    add_reference :deals, :user, index: true
    add_reference :deals, :report, index: true
  end
end
