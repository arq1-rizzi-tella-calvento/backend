class CreateSubjectInQuarters < ActiveRecord::Migration[5.1]
  def change
    create_table :subject_in_quarters do |t|
      t.belongs_to :subject
      t.belongs_to :survey
      t.timestamps
    end
  end
end
