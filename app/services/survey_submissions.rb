class SurveySubmissions
  INVALID_ANSWER = Class.new(StandardError)
  ExpiredSurveyPeriodError = Class.new(StandardError)
  InvalidSurveyActionError = Class.new(StandardError)

  def obtain_answers(survey, student)
    Answer.where(survey_id: survey.id, student_id: student.id)
  end

  def last_survey_subjects(survey, student)
    approved_subject_ids = student.subjects.pluck(:id)
    survey.subjects.where.not(id: approved_subject_ids)
  end

  def create_answers(student, survey, new_submission_args)
    raise InvalidSurveyActionError if obtain_answers(survey, student).exists?

    ActiveRecord::Base.transaction do
      answers_to_create = new_submission_args.reject do |data|
        data[:selected].blank? || not_this_quarter?(data[:selected])
      end
      build_new_answers(answers_to_create, survey, student)
    end
  end

  def update_answers(student, survey, new_submission_args)
    ActiveRecord::Base.transaction do
      student_answers = obtain_answers(survey, student)
      new_answers = new_submission_args.select { |answer_data| new_answer?(student_answers, answer_data) }

      updated_answers = edit_answers(student_answers, new_submission_args - new_answers)
      updated_answers.concat build_new_answers(new_answers, survey, student)
    end
  end

  def current_survey
    Survey.includes(subjects: :chairs).select(:id).active.last.tap do |survey|
      raise ExpiredSurveyPeriodError if survey.blank?
    end
  end

  def find_survey(survey_id)
    @survey_id ||= Survey.find(survey_id)
  rescue ActiveRecord::RecordNotFound
    raise SurveySubmissions::ExpiredSurveyPeriodError
  end

  private

  def build_new_answers(new_answers, survey, student)
    new_answers.map do |answer_data|
      Answer.new(survey: survey, student: student).tap do |answer|
        selection = answer_data[:selected]
        subject = find_subject(answer_data[:name])
        update_answer(answer, subject, selection)

        answer.save!
      end
    end
  end

  def edit_answers(student_answers, new_submission_args)
    student_answers.map do |an_answer|
      an_answer.tap do |answer|
        new_answer = new_submission_args.detect { |arg| arg[:name] == answer.subject_name }
        next unless new_answer && new_answer[:selected]
        selection = new_answer[:selected]

        answer.destroy! && next if not_this_quarter?(selection)
        update_answer(answer, answer.subject, selection)

        answer.save!
      end
    end.reject(&:destroyed?)
  end

  def update_answer(answer, subject, selection)
    schedule_conflict?(selection) ? with_conflict(answer, subject) : with_chair(answer, selection)
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
    selection = answer_data[:selected]
    selection.present? && !not_this_quarter?(selection) &&
      previous_answers.none? { |answer| answer.subject_name == answer_data[:name] }
  end
end
