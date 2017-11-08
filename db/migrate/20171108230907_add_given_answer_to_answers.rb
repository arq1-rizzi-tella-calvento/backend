class AddGivenAnswerToAnswers < ActiveRecord::Migration[5.1]
  def change
    change_table(:answers) do |t|
      t.belongs_to :chair
      t.belongs_to :reply_option
    end
  end
end
