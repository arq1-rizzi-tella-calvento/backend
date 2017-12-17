module SurveyService
  def generate_success_message(success_message, edit_link)
    success_message = if success_message.empty?
                        { subjects: [], link: edit_link }
                      else
                        { subjects: success_message, link: edit_link }
                      end
    success_message.to_json
  end

  def generate_link(server_name, token)
    "#{server_name}/survey/#{token}/edit"
  end

  def generate_survey(student, success_message)
    find_survey(params[:surveyId])
    params[:subjects].each do |subject|
      current_subject = Subject.find_by!(name: subject[:name])
      student_answer = subject[:selectedChair]
      if available_chair(student_answer)
        success_message =
          submit_answer(current_subject, student_answer, subject, success_message, student.id)
      end
    end
    success_message
  end

  def available_chair(student_answer)
    !student_answer.nil? && student_answer != Answer::APRROVED_SUBJECT && student_answer != Answer::NOT_THIS_QUARTER
  end

  def submit_answer(current_subject, student_answer, subject, success_message, student_id)
    Answer.new.tap do |answer|
      answer.student_id = student_id
      answer.survey_id = @survey_id
      if student_answer == Answer::SCHEDULE_PROBLEM
        answer.reply_option = generate_reply_option(current_subject)
      else
        chair = find_chair_by_student_answer(answer, student_answer)
        success_message = success_message.push(
          subject_name: subject[:name], time: chair_description(chair)
        )
      end
      answer.save!
    end
    success_message
  end

  def chair_description(chair)
    "C#{chair.number} - #{chair.time}"
  end

  def find_survey(survey_id)
    @survey_id ||= Survey.find(survey_id)
  rescue ActiveRecord::RecordNotFound
    raise SurveySubmissions::ExpiredSurveyPeriodError
  end

  def find_chair_by_student_answer(answer, student_answer)
    chair = Chair.find(student_answer)
    answer.chair = chair
    chair
  end

  def generate_reply_option(subject)
    ReplyOption.new.tap do |a_reply_option|
      a_reply_option.value = 'No voy a cursar'
      a_reply_option.subject = subject
      a_reply_option.save!
    end
  end

  def build_survey(survey, survey_subjects)
    {
      subjects: survey_subjects.map do |subject|
        {
          name: subject.name,
          id: subject.id,
          selected: '',
          chairs: subject.chairs.map do |chair|
            {
              id: chair.id,
              time: chair_description(chair)
            }
          end
        }
      end,
      survey_id: survey.id
    }
  end

  def build_editable_survey(answers, subjects, survey)
    answers_info = answers.map(&:choice_info)
    build_survey(survey, subjects).tap do |a_survey|
      a_survey[:subjects].map do |survey_subject|
        answer = answers_info.detect { |info| info[:name] == survey_subject[:name] }
        survey_subject.tap { |subject| subject[:selected] = answer[:selected] if answer.present? }
      end
    end
  end
end
