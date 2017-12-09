class AddSubjectToReplyOption < ActiveRecord::Migration[5.1]
  def change
    change_table :reply_options do |t|
      t.belongs_to :subject
    end
  end
end
