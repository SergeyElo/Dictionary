require 'yaml'    # для работы с YAML файлами

class Dictionary

  attr_accessor :len, :file_name, :usl, :words

  # инициализация словаря, если параметры не заданы, берутся по умолчанию
  def initialize(file_name="", len=0, usl="", words={})
    @len = len
    @file_name = file_name
    @usl = usl
    @words = words
  end

  # Информация о словаре
  def Name
    "  Dict name '#{@file_name}' size: #{File.size(@file_name)} date: #{File.mtime(@file_name)}"
  end
  # если файл существует, то чтение из файла в хеш, иначе пусто
  def ReadFromFile
    if File.exist?(@file_name)
      @words = YAML.load_file(@file_name)
      puts "  Dictionary was readed."
    else
      @words = {}
      puts "  Dictionary not readed: file #{@file_name} not exists."
    end
  end
  # если хэш не пустой, запись его в файл
  def WriteToFile
    if !@words.empty? && file_name != ""
      File.open(@file_name, 'w') { |f| f.write(@words.to_yaml) }
      puts "  Dictionary was saved."
    else
      puts "  Empty dictionary or filename. File not saved."
    end
  end
  # Ввод нового слова и если оно удовлетворяет условиям, то добавить в словарь
  def Add
    print "Input word: "
    key = gets.chomp.upcase
    print "Input translate: "
    value = gets.chomp.upcase
    if key.match(usl) && key.length == len
      @words[key] = value
      puts "Word #{key} was added."
    else
      puts "Incorrect word"
    end
  end
  # Вывод словаря
  def Print
    if !@words.empty?
      n = 0
      @words.each {|key, val| puts "#{n += 1}).\t#{key}\t-\t#{val}" }
    else
      puts "Dictionary is empty."
    end
  end
  def Find
    print "Input find word: "
    fkey = gets.chomp.upcase
    puts @words.has_key?(fkey) ? "#{fkey} - #{@words[fkey]}" : "not founded!"
  end
  def Delete
    print "Input delete word:"
    fkey = gets.chomp.upcase
    @words.delete(fkey) { |fkey| "not founded!"}
    puts fkey
  end
end
dic_first = Dictionary.new('dict_a.yml', 4, /^[a-zA-Z]+$/)
dic_second = Dictionary.new('dict_b.yml', 5, /^[0-9]+$/)
dic = nil
begin
  if dic == nil
    begin
      print "Select type dictionary 1-first 2-second 0-exit. Input: "
      s = gets.chomp
      s.match(/^[0,1,2]/) ? num = s.to_i : num = -1
    end until num != -1
    if num > 0
      num == 1 ? dic = dic_first :  dic = dic_second
    else
      dic = nil
    end
  end
  if dic != nil
    puts dic.Name
    begin
      begin
        puts "1-print dict 2-add word 3-del word 4-find word 5-read dic 6-save dic 7-change dic 0-exit"
        print "Input num: "
        s = gets.chomp
        s.match(/^[0-7]/) ? num = s.to_i : num = -1
      end until num != -1
      case num
      when 1 then dic.Print
      when 2 then dic.Add
      when 3 then dic.Delete
      when 4 then dic.Find
      when 5 then dic.ReadFromFile
      when 6 then dic.WriteToFile
      when 7 then dic = nil
      end
    end until num == 0 || dic == nil
  end
end until num == 0