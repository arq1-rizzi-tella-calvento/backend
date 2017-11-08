class CreateReplyOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :reply_options do |t|
      t.string :value
      t.timestamps
    end
  end
end
