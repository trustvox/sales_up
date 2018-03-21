class AddReferencesIntoContract < ActiveRecord::Migration[5.1]
  def change
    add_reference :contracts, :user, index: true
    add_reference :contracts, :report, index: true
  end
end
