class CreateJoinTableSubjectsReplyOptions < ActiveRecord::Migration[5.1]
  def change
    create_join_table :subjects, :reply_options do |t|
      t.index [:subject_id, :reply_option_id]
      t.index [:reply_option_id, :subject_id]
    end
  end
end
