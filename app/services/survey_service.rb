module SurveyService
  def generate_success_message(success_message)
    success_message = if success_message.empty?
                        { subjects: [], link: 'link para editar la encuesta' }
                      else
                        { subjects: success_message, link: 'link para editar la encuesta' }
                      end
    success_message.to_json
  end

  def submit_answer(current_subject, student_answer, subject, success_message)
    Answer.new.tap do |answer|
      answer.student_id = params[:userId]
      if !student_answer || student_answer == 'cant' || student_answer == ''
        answer.reply_option = generate_reply_option
      else
        chair = find_chair_by_student_answer(answer, current_subject, student_answer, subject)
        success_message = success_message.push(subject_name: subject[:name], time: chair.time)
      end
      answer.save!
    end
    success_message
  end

  def find_chair_by_student_answer(answer, current_subject, student_answer, subject)
    chair = current_subject.subject_in_quarter.chairs.detect { |a_chair| a_chair.time == subject[:selectedChair] }
    answer.chair_id = student_answer
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
    survey_subjects.map { |subject| { name: subject.name, chairs: subject.chairs.map(&:time) } }
  end
end