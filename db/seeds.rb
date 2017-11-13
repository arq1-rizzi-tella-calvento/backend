# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

subjects = [
  "Inglés I", "Inglés II", "Intro", "Orga", "Mate I", "Estructuras", "Objetos I", "BBDD", "Arduino", "Labo",
  "Objetos II", "Persistencia", "Seguridad", "Interfaces", "Objetos III", "Concurrente", "Ingeniería", "Redes",
  "Funcional", "Desarrollo", "Mate II", "TIP", "SO", "Gestión", "Análisis", "Requerimientos", "Desarrollo", "LFA",
  "Sistemas"
].map { |subject_name| FB.create :subject }

survey = FB.create :survey

subjects_in_quarter = subjects.map do |subject|
  subject_in_quarter = FB.create :subject_in_quarter, survey: survey, subject: subject
  FB.create :chair, quota: 9, subject_in_quarter: subject_in_quarter
end

students = (1..10).map { |_| FB.create :student }

students.take(3).each do |student|
  student.subjects = subjects.take(10)
  student.save!
end

students.each { |student| FB.create :answer, student: student, chair: Chair.last }