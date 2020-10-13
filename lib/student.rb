class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
   new_student = self.new
   new_student.name = row[1]
   new_student.grade = row[2]
   new_student.id = row[0]
   new_student
  end

  def self.all
  all_students = []
  sql = <<-SQL
   SELECT * FROM students
   SQL
   DB[:conn].execute(sql).map do |row|
     new_student = self.new_from_db(row)
     all_students << new_student
   end
   all_students
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.name = ?
      LIMIT 1
      SQL
      DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def self.all_students_in_grade_9
    grade_9_students = []
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.grade = 9
      SQL
      DB[:conn].execute(sql).map do |row|
      student = self.new_from_db(row)
      grade_9_students << student
    end
    grade_9_students
  end
  
  def self.students_below_12th_grade
    students = []
    sql = <<-SQL
    SELECT * FROM students
    WHERE students.grade < 12
    SQL
    DB[:conn].execute(sql).map do |row|
      student = self.new_from_db(row)
    students << student
    end
  students
  end
 
 def self.first_X_students_in_grade_10(x)
   students = []
   sql = <<-SQL
   SELECT * FROM students
   WHERE students.grade = 10
  SQL
  DB[:conn].execute(sql).map do |row|
    student = self.new_from_db(row)
    students << student
  end
  students[0,x]
end
   
 def self.first_student_in_grade_10
   students = []
   sql = <<-SQL
   SELECT * FROM students
   WHERE students.grade = 10
  SQL
  DB[:conn].execute(sql).map do |row|
    student = self.new_from_db(row)
    students << student
  end
  students[0]
end
 
 def self.all_students_in_grade_X(grade)
   students = []
   sql = <<-SQL
   SELECT * FROM students
   WHERE students.grade = ?
  SQL
  DB[:conn].execute(sql, grade).map do |row|
    student = self.new_from_db(row)
    students << student
  end
  students
end


  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
