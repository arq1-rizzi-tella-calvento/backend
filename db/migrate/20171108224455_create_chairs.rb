class CreateChairs < ActiveRecord::Migration[5.1]
  def change
    create_table :chairs do |t|
      t.belongs_to :subject
      t.integer :quota, default: 0
      t.timestamps
    end
  end
end
