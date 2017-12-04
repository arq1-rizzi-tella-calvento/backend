require 'rails_helper'

describe AcademicRecord do
  context '#enroll_student' do
    let(:new_student) { build(:student) }
    let(:subjects) { [build(:subject), build(:subject)] }

    it 'assigns the student approved subjects before saving' do
      student = subject.enroll_student(new_student, subjects)

      expect(student.subjects).to match_array subjects
    end
  end

  context '#register_students' do
    let(:student_email) { 'student@email.com' }
    let(:another_student_email) { 'anotherstudent@email.com' }
    let(:student_emails) { [student_email, another_student_email] }

    it 'creates new students with the given emails' do
      expect do
        subject.register_students(student_emails)
      end.to change { Student.count }.by(2).and create_student_with(email: student_email)
        .and create_student_with(email: another_student_email)
    end

    it 'assigns a token to the new students' do
      subject.register_students([student_email])

      student = Student.find_by(email: student_email)
      expect(student.token).to be_present
    end

    def create_student_with(email:)
      change { Student.exists? email: email }.from(false).to(true)
    end
  end
end
