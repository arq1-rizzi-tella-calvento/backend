class AcademicRecord
  def enroll_student(student, approved_subjects)
    student.tap do |a_student|
      a_student.subjects = approved_subjects
      a_student.save!
    end
  end
end