class AddIndexToSurveyDates < ActiveRecord::Migration[5.1]
  def change
    change_table :surveys do |t|
      t.index :start_date, unique: true
      t.index :end_date, unique: true
    end
  end
end
