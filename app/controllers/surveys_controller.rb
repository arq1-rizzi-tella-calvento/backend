class SurveysController < ApplicationController
  def create
    success_message = ''
    params[:subjects].each do |subject|
      current_subject = Subject.find_by(name: subject[:name])
      student_answer = subject[:condition]
      if student_answer == 'approve'
      #   tenemos que asignarla a las materias aprobadas no como una respuesta
      else
        success_message = submit_answer(current_subject, student_answer, subject, success_message)
      end
    end

    render json: { message: generate_success_message(success_message) }, status: :ok
  end

  def new
    approved_subject_ids = Student.includes(:subjects).find(student_id).subjects.pluck(:id)
    survey_subjects = Survey.includes(:subjects).last.subjects.where.not(id: approved_subject_ids)

    render json: build_survey(survey_subjects), status: :ok
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  private

  def student_id
    params.permit(:student_id)[:student_id]
  end

  def build_survey(survey_subjects)
    survey_subjects.map { |subject| { name: subject.name, chairs: subject.chairs.map(&:time) } }
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
        chair = current_subject.subject_in_quarter.chairs.detect { |chair| chair.time == subject[:condition] }
        success_message = success_message + ' , ' + subject[:name] + ' comision: ' + chair.time
        answer.chair_id = student_answer
        answer.chair = chair
      end
      answer.save!
    end
    success_message
  end

  def generate_success_message(success_message)
    if success_message.empty?
      success_message = 'Survey successfully submitted'
    else
      success_message = 'Survey details : ' + success_message
    end
    success_message
  end
end
