class ChangeAnswers < ActiveRecord::Migration[5.2]
  change_table :answers do |t|
    t.remove :title
  end
end
