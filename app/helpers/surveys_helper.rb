module SurveysHelper

  def generate_success_message(success_message)
    if success_message.empty?
      success_message = { subjects: [] , link: 'https://shocrisklidad.wixsite.com/rickypageweb' }
    else
      success_message = { subjects: success_message , link: 'http://shocrisklidad.wixsite.com/rickypageweb' }
    end
    success_message.to_json
  end

  def submit_answer(current_subject, student_answer, subject, success_message)
    Answer.new.tap do |answer|
      answer.student_id = params[:userId]
      if !student_answer || student_answer == 'cant' || student_answer == ''
        reply_option = ReplyOption.new.tap do |replyOption|
          replyOption.value = 'No voy a cursar'
          replyOption.save!
        end
        answer.reply_option = reply_option
      else
        chair = current_subject.subject_in_quarter.chairs.detect { |chair| chair.time == subject[:selectedChair] }
        success_message = success_message.push ({ subject_name: subject[:name] , time: chair.time })
        answer.chair_id = student_answer
        answer.chair = chair
      end
      answer.save!
    end
    success_message
  end

  def build_survey(survey_subjects)
    survey_subjects.map { |subject| { name: subject.name, chairs: subject.chairs.map(&:time) } }
  end
end