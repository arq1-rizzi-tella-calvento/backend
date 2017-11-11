require 'rails_helper'

describe AcademicRecord do
  let(:new_student) { build(:student) }
  let(:subjects) { [build(:subject), build(:subject)] }

  it 'Saves the new student in the database' do
    expect { subject.enroll_student(new_student, subjects) }.to change { Student.count }.by 1
  end

  it 'assigns the student approved subjects before saving' do
    student = subject.enroll_student(new_student, subjects)

    expect(student.subjects).to match_array subjects
  end
end