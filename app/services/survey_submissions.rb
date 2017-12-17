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
      new_answers = new_submission_args.select { |answer_data| new_answer?(student_answers, answer_data) }

      edit_answers(student_answers, new_submission_args - new_answers)
      build_new_answers(new_answers, survey, student).map(&:save!)
    end
  end

  def current_survey
    Survey.includes(subjects: :chairs).select(:id).active.last.tap do |survey|
      raise ExpiredSurveyPeriodError if survey.blank?
    end
  end

  private

  def build_new_answers(new_answers, survey, student)
    new_answers.map do |answer_data|
      Answer.new(survey: survey, student: student).tap do |answer|
        selection = answer_data[:selectedChair]
        name = answer_data[:name]
        schedule_conflict?(selection) ? with_conflict(answer, find_subject(name)) : with_chair(answer, selection)
      end
    end
  end

  def edit_answers(student_answers, new_submission_args)
    student_answers.each do |answer|
      new_answer = new_submission_args.detect { |arg| arg[:name] == answer.subject_name }
      next unless new_answer && new_answer[:selectedChair]
      selection = new_answer[:selectedChair]

      answer.destroy! && next if not_this_quarter?(selection)
      schedule_conflict?(selection) ? with_conflict(answer, answer.subject) : with_chair(answer, selection)

      answer.save!
    end
  end

  def not_this_quarter?(selection)
    selection == Answer::NOT_THIS_QUARTER
  end

  def schedule_conflict?(selection)
    selection == Answer::SCHEDULE_PROBLEM
  end

  def with_chair(answer, selected_chair)
    answer.chair = obtain_chair(selected_chair)
    answer.reply_option.try(:destroy!)
  end

  def with_conflict(answer, subject)
    answer.reply_option = ReplyOption.with_conflicting_schedules(subject)
    answer.chair = nil
  end

  def obtain_chair(selected_chair)
    Chair.find(selected_chair)
  rescue ActiveRecord::RecordNotFound
    raise INVALID_ANSWER
  end

  def find_subject(subject_name)
    Subject.select(:id).find_by(name: subject_name)
  end

  def new_answer?(previous_answers, answer_data)
    answer_data[:selectedChair].present? && answer_data[:selectedChair] != Answer::NOT_THIS_QUARTER &&
      previous_answers.none? { |answer| answer.subject_name == answer_data[:name] }
  end
end
