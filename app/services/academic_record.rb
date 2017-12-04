class AcademicRecord
  def enroll_student(student, approved_subjects)
    student.tap do |a_student|
      a_student.subjects = approved_subjects
      a_student.save!(context: :enroll)
    end
  end

  def answers_percentage
    students_count = Student.count
    return 0 if students_count.zero?

    students_that_answered = current_survey.answers.select(:student_id).distinct
    students_that_answered.count * 100 / students_count
  end

  def survey_summary
    Survey.includes(subject_in_quarters: { chairs: :answers }).last.subject_in_quarters.flat_map do |subject|
      chairs = subject.chairs.map do |chair|
        {
          name: subject.name,
          chair: chair.number,
          number_of_students: chair.number_of_students,
          fullness_percentage: chair.fullness_percentage
        }
      end
      chairs.sort_by { |data| data[:chair] }
    end
  end

  def register_students(student_emails)
    student_emails.each { |email| Student.create!(email: email) }
  end

  def find_student_with(token:)
    Student.find_by!(token: token)
  end

  private

  def current_survey
    Survey.last
  end
end
