# CreateUsers is responsible to add a new record called User which will
#   store the full_name, email and password of a user inside the application
class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
