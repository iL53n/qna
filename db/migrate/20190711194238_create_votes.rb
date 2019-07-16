class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :vote, default: 0
      t.references :voteable, polymorphic: true
      t.references :user

      t.index(%i[voteable_type voteable_id user_id], unique: true)

      t.timestamps
    end
  end
end
