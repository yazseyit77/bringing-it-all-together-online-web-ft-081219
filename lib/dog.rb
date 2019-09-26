class Dog
  attr_accessor :name, :breed, :id
  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      );
      SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE dogs;
      SQL

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    self
  end

  def self.create(hash_of_attributes)
    dog = Dog.new(hash_of_attributes)
    dog.save
    dog
  end

  def self.new_from_db(row)
    attr_hashes = {
      id: row[0],
      name: row[1],
      breed: row[2]
    }
    self.new(attr_hashes)
  end

  def self.find_by_id(id)
    "SELECT * FROM dogs WHERE id = ?;"
  end
end
