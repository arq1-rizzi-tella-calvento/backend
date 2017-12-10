class SurveySubmissions
  def obtain_answers(survey, student)
    Answer.where(survey_id: survey.id, student_id: student.id)
  end

  def last_survey_subjects(student)
    approved_subject_ids = student.subjects.pluck(:id)
    Survey.includes(subjects: :chairs).last.subjects.where.not(id: approved_subject_ids)
  end
end
