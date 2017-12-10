module SurveyService
  def generate_success_message(success_message)
    success_message = if success_message.empty?
                        { subjects: [], link: 'link para editar la encuesta' }
                      else
                        { subjects: success_message, link: 'link para editar la encuesta' }
                      end
    success_message.to_json
  end

  def generate_survey(student, success_message)
    params[:subjects].each do |subject|
      current_subject = Subject.find_by(name: subject[:name])
      student_answer = subject[:selectedChair]
      if student_answer != 'approved'
        success_message =
          submit_answer(current_subject, student_answer, subject, success_message, student.id)
      end
    end
    success_message
  end

  def submit_answer(_current_subject, student_answer, subject, success_message, student_id)
    Answer.new.tap do |answer|
      answer.student_id = student_id
      if !student_answer || student_answer == 'cant' || student_answer == 'dont'
        answer.reply_option = generate_reply_option
      else
        chair = find_chair_by_student_answer(answer, student_answer)
        success_message = success_message.push(subject_name: subject[:name], time: chair.time)
      end
      answer.save!
    end
    success_message
  end

  def find_chair_by_student_answer(answer, student_answer)
    chair = Chair.find(student_answer)
    answer.chair = chair
    chair
  end

  def generate_reply_option
    ReplyOption.new.tap do |a_reply_option|
      a_reply_option.value = 'No voy a cursar'
      a_reply_option.save!
    end
  end

  def build_survey(survey_subjects)
    survey_subjects.map do |subject|
      {
        name: subject.name,
        id: subject.id,
        chairs: subject.chairs.map { |chair| { id: chair.id, time: chair.time } }
      }
    end
  end
end
