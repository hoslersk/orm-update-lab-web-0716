require_relative "../config/environment.rb"
require 'pry'

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER);")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students;")
  end

  def save
    if self.id
      #self.update
      DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?;", self.name, self.grade, self.id)
    else
      DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)", self.name, self.grade)
      results = DB[:conn].execute("SELECT students.id FROM students ORDER BY students.id DESC LIMIT 1;")
      @id = results[0][0]
    end
  end

  def self.create(name, grade)
    DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)", name, grade)
  end

  def self.new_from_db(row)
    new_student = self.new(row[1], row[2], row[0])
    new_student
  end

  def self.find_by_name(name)
    results = DB[:conn].execute("SELECT * FROM students WHERE students.name = ?", name)
    if results[0][1] == name
      self.new_from_db(results[0])
    end
  end

  def update
    DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?", self.name, self.grade, self.id)
  end

end
