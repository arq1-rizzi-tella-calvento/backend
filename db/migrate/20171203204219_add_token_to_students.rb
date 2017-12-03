class AddTokenToStudents < ActiveRecord::Migration[5.1]
  def change
    change_table(:students) do |t|
      t.string :token
      t.index :token, unique: true
    end
  end
end
