class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.belongs_to :student
      t.belongs_to :survey
      t.timestamps
    end
  end
end
