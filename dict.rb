require "json"

class Glossary

  attr_accessor :words, :type, :file_name

  def initialize(params)
    @words = params[:words]
    @type = params[:type]
    @file_name = params[:file_name]
  end

  def words
    words = @words
  end

  def type
    type = @type
  end

  def condition
    condition = type == 1 ? /^[a-zA-Z]{4}$/ : /^[0-9]{5}$/
  end

  def input(mes)
    print mes
    s = gets.chomp
    s = "" if s == nil
    s.upcase
  end

  def Load
    self.words = JSON.parse(File.read(file_name)) if File.exist?(file_name)
  end

  def Save
    if !self.words.empty? && file_name != ""
      File.open(file_name, "w") { |f| f.write self.words.to_json }
    end
  end

  def Print(all = false)
    puts "Selected Dictionary N #{self.type}."
    self.words.map { |key, val|
      if (!all && key.match(self.condition)) || all
        puts "#{key}-#{val}"
      end
    }
  end

  def Add
    key = input("Input word:")
    value = input("Input translate:")
    if key.match(condition) && value != ""
      if self.words.has_key?(key)
        s = input("#{key} already in dictionary. Are you sure you need to add (y/n)?")
      else
        s = 'y'
      end
      if s.match(/^[yY]${1}/)
        words[key] = value
        self.Save
        puts "#{key} added."
      else
        puts "Not added!"
      end
    else
      puts "Incorrect input! Word not added."
    end
  end

  def Find
    key = input("What to search?")
    if self.words.has_key?(key) && key.match(condition)
      puts "#{key}-#{self.words[key]}"
    else
      puts "not founded!"
    end
  end

  def Delete
    key = input("What to delete?")
    if self.words.has_key?(key)
      self.words.delete(key)
      self.Save
      puts "#{key} deleted."
    else
      puts "Not deleted, because not founded."
    end
  end

end

def menu
  begin
    print "1-select dictionary 2-view dictionary 3-add word 4-find word " +
          "5-delete word 6-view all 0-exit. Input num: "
    n = gets.chomp
  end until n.match(/^[0-6]{1}$/)
  return n.to_i
end

dict = Glossary.new(:type => 1, :file_name => 'dict.json')
dict.Load
loop do
  case menu
  when 0 then break
  when 1 then
    begin
      print "Select dictionary (1, 2)? "
      snum = gets.chomp
    end until snum.match(/^[1,2]{1}$/)
    dict.type = snum.to_i
  when 2 then dict.Print
  when 3 then dict.Add
  when 4 then dict.Find
  when 5 then dict.Delete
  when 6 then dict.Print(true)
  end
end

