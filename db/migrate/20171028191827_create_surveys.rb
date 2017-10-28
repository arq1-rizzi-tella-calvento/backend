class CreateSurveys < ActiveRecord::Migration[5.1]
  def change
    create_table :surveys do |t|
      t.date :start_date
      t.date :end_date
      t.integer :quarter
      t.timestamps
    end
  end
end
