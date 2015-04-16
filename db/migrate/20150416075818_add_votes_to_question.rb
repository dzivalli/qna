class AddVotesToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :votes, :integer, null: false, default: 0
  end
end
