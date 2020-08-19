class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = "SELECT * FROM students"
    DB[:conn].execute(sql).collect {|s| self.new_from_db(s)}
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    self.new_from_db(result)
  end

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    DB[:conn].execute(sql).collect {|a| self.new_from_db(a)}
  end

  def self.first_X_students_in_grade_10(num)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    DB[:conn].execute(sql, num).collect {|a| self.new_from_db(a)}
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    DB[:conn].execute(sql).collect {|a| self.new_from_db(a)}[0]
  end
  
  def self.all_students_in_grade_X(grade)
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql, grade).collect {|a| self.new_from_db(a)}
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
