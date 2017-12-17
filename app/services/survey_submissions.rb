class SurveySubmissions
  INVALID_ANSWER = Class.new(StandardError)
  ExpiredSurveyPeriodError = Class.new(StandardError)

  def obtain_answers(survey, student)
    Answer.where(survey_id: survey.id, student_id: student.id)
  end

  def last_survey_subjects(survey, student)
    approved_subject_ids = student.subjects.pluck(:id)
    survey.subjects.where.not(id: approved_subject_ids)
  end

  def update_answers(student, survey, new_submission_args)
    ActiveRecord::Base.transaction do
      student_answers = obtain_answers(survey, student)
      new_answers = new_submission_args.select do |arg|
        arg[:selectedChair].present? && student_answers.none? { |answer| answer.subject_name == arg[:name] }
      end

      edit_answers(student_answers, new_submission_args - new_answers)
      create_new_answers(new_answers, survey, student)
    end
  end

  def current_survey
    Survey.includes(subjects: :chairs).select(:id).active.last.tap do |survey|
      raise ExpiredSurveyPeriodError if survey.blank?
    end
  end

  private

  def create_new_answers(new_answers, survey, student)
    new_answers.each do |answer|
      Answer.create!(survey: survey, student: student, chair: obtain_chair(answer[:selectedChair]))
    end
  end

  def edit_answers(student_answers, new_submission_args)
    student_answers.each do |answer|
      new_answer = new_submission_args.detect { |arg| arg[:name] == answer.subject_name }
      next unless new_answer && new_answer[:selectedChair]
      selection = new_answer[:selectedChair]

      answer.destroy! && next if not_this_quarter?(selection)
      schedule_conflict?(selection) ? edited_with_conflict(answer) : edited_with_chair(answer, selection)

      answer.save!
    end
  end

  def not_this_quarter?(selection)
    selection == Answer::NOT_THIS_QUARTER
  end

  def schedule_conflict?(selection)
    selection == Answer::SCHEDULE_PROBLEM
  end

  def edited_with_chair(answer, selected_chair)
    answer.chair = obtain_chair(selected_chair)
    answer.reply_option.try(:destroy!)
  end

  def edited_with_conflict(answer)
    answer.reply_option = ReplyOption.with_conflicting_schedules(answer.chair.subject)
    answer.chair = nil
  end

  def obtain_chair(selected_chair)
    Chair.find(selected_chair)
  rescue ActiveRecord::RecordNotFound
    raise INVALID_ANSWER
  end
end
