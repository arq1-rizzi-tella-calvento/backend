module SurveyService
  def generate_link(server_name, token)
    "#{server_name}/survey/#{token}/edit"
  end

  def generate_survey_response(answers, student)
    {
      subjects: answers.map { |answer| { subject_name: answer.subject_name, time: description(answer) } },
      link: generate_link(@_request.origin, student.token)
    }
  end

  def description(answer)
    return answer.reply_option.value if answer.selection == Answer::SCHEDULE_PROBLEM
    chair_description answer.chair
  end

  def chair_description(chair)
    "C#{chair.number} - #{chair.time}"
  end

  def build_survey(survey, survey_subjects)
    {
      subjects: survey_subjects.map do |subject|
        {
          name: subject.name,
          id: subject.id,
          selected: '',
          chairs: subject.chairs.map { |chair| { id: chair.id, time: chair_description(chair) } }
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
