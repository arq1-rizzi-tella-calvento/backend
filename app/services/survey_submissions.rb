class SurveySubmissions
  INVALID_ANSWER = Class.new(StandardError)

  def obtain_answers(survey, student)
    Answer.where(survey_id: survey.id, student_id: student.id)
  end

  def last_survey_subjects(student)
    approved_subject_ids = student.subjects.pluck(:id)
    Survey.includes(subjects: :chairs).last.subjects.where.not(id: approved_subject_ids)
  end

  def update_answers(student, survey, new_submission_args)
    ActiveRecord::Base.transaction do
      obtain_answers(survey, student).each do |answer|
        new_answer = new_submission_args.detect { |arg| arg[:name] == answer.subject_name }
        next unless new_answer && new_answer[:selectedChair]

        selection = new_answer[:selectedChair]
        answer.destroy! && next if not_this_quarter?(selection)

        schedule_conflict?(selection) ? edited_with_conflict(answer) : edited_with_chair(answer, selection)
        answer.save!
      end
    end
  end

  private

  def not_this_quarter?(selection)
    selection == Answer::NOT_THIS_QUARTER
  end

  def schedule_conflict?(selection)
    selection == Answer::SCHEDULE_PROBLEM
  end

  def edited_with_chair(answer, selected_chair)
    answer.chair = Chair.find(selected_chair)
    answer.reply_option.try(:destroy!)
  rescue ActiveRecord::RecordNotFound
    raise INVALID_ANSWER
  end

  def edited_with_conflict(answer)
    answer.reply_option = ReplyOption.with_conflicting_schedules(answer.chair.subject)
    answer.chair = nil
  end
end
