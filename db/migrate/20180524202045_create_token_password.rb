class CreateTokenPassword < ActiveRecord::Migration[5.1]
  def change
    create_table :token_passwords do |t|
      t.string :token
      t.string :used
    end
  end
end
