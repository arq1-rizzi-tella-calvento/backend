class CreateApprovedSubjects < ActiveRecord::Migration[5.1]
  def change
    create_table :approved_subjects do |t|
      t.belongs_to :student
      t.belongs_to :subject
      t.timestamps
    end
  end
end
