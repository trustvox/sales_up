class AddUserRefInToken < ActiveRecord::Migration[5.1]
  def change
    add_reference :token_passwords, :user, index: true
  end
end
