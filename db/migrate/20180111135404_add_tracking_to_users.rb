class AddTrackingToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :tracking, :string
  end
end
