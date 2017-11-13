class CreateChairs < ActiveRecord::Migration[5.1]
  def change
    create_table :chairs do |t|
      t.belongs_to :subject_in_quarter
      t.integer :quota, default: 0
      t.string :time
      t.timestamps
    end
  end
end
