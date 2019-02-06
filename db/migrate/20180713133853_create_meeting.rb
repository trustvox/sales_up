class CreateMeeting < ActiveRecord::Migration[5.1]
  def change
    create_table :meetings do |t|
      t.integer  :day,          null: false, default: 0
      t.string   :client_name,  null: false, default: ""
      t.datetime :scheduled_for
      t.decimal  :value,        null: false, default: 0

      t.timestamps
    end

    add_reference :meetings, :report, index: true
    add_reference :meetings, :user, index: true
  end
end
