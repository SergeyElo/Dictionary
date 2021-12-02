require 'json'    # для работы с JSON файлами

class Dictionary  # класс для работы со словарем
  attr_accessor :file_name, :usl, :words

  # инициализация словаря, если параметры не заданы, берутся по умолчанию
  def initialize(file_name="", usl="", words={})
    @file_name = file_name
    @usl = usl
    @words = words
  end

  # Информация о словаре название файла, размер, дата
  def Name
    sname = "========== Dict name '#{@file_name} "
    if File.exist?(@file_name)
      sname += "size: #{File.size(@file_name)} date: #{File.mtime(@file_name)} "
    end
    sname += "=" * 10
  end

  # если файл существует, то чтение из файла JSON и преобразование в хеш, иначе пусто
  def ReadFromFile
    if File.exist?(@file_name)
      @words = JSON.parse(File.read(file_name))
      puts "  Dictionary was readed."
    else
      @words = {}
      puts "  Dictionary not readed: file #{@file_name} not exists."
    end
  end

  # если словарь (хэш) не пустой, записать в файл, преобразовав из хеша в JSON
  def WriteToFile
    if !@words.empty? && file_name != ""
      File.open(@file_name,"w") { |f| f.write @words.to_json }
      puts "  Dictionary was saved."
    else
      puts "  Empty dictionary or filename. File not saved."
    end
  end

  # Ввод нового слова и если оно удовлетворяет условиям, то добавить в словарь
  def Add
    print "  Input word: "
    key = gets.chomp.upcase
    print "  Input translate: "
    value = gets.chomp.upcase
    if key.match(usl)
      @words[key] = value
      puts "  Word #{key} was added."
    else
      puts "  Incorrect word"
    end
  end

  # Вывод словаря
  def Print
    if !@words.empty?
      n = 0
      @words.each {|key, val| puts "#{n += 1}).\t#{key}\t-\t#{val}" }
    else
      puts "  Dictionary is empty."
    end
  end

  # запрос что искать, поиск по ключу (слову)
  def Find
    print "  Input find word: "
    fkey = gets.chomp.upcase
    puts @words.has_key?(fkey) ? "#{fkey} - #{@words[fkey]}" : "not founded!"
  end

  # запрос ввода слова, поиск и удаление, если найдено
  def Delete
    print "  Input delete word:"
    fkey = gets.chomp.upcase
    mes = "Word #{fkey} was deleted."
    mes = @words.delete(fkey) { |fkey| "not founded!"}
    puts mes
  end

end

# Первый словарь в файле dict_a.json, ограничения на слова (ключи) - только 4 латинские буквы
dic_first = Dictionary.new('dict_a.json', /^[a-zA-Z]{4}$/)

# Второй словарь в файле dict_b.json, ограничения на слова (ключи) - только 5 цифр
dic_second = Dictionary.new('dict_b.json',/^[0-9]{5}$/)

# текущий словарь пока не выбран
dic = nil

# начало цикла выбора в меню (завершается если выбрано 0 - exit )
begin

  # если текущий словарь не выбран - меню выбор словаря
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
  end  # конец условия текущий словарь не выбран

  # если текущий словарь выбран, то выводится меню выбора режима работы со словарем
  # выход когда выбрано 0 - exit или 7 - выбор словаря
  if dic != nil
    puts dic.Name
    begin
      # начало цикла проверки выбора пункта меню
      begin
        print "1-print dict 2-add word 3-del word 4-find word " +
                " 5-read dic 6-save dic 7-change dic 0-exit. Input num: "
        s = gets.chomp
        s.match(/^[0-7]{1}$/) ? num = s.to_i : num = -1
      end until num != -1   # конец цикла проверки выбора пункта меню
      # выполнение выбранного пункта меню
      case num
      when 1 then dic.Print
      when 2 then dic.Add
      when 3 then dic.Delete
      when 4 then dic.Find
      when 5 then dic.ReadFromFile
      when 6 then dic.WriteToFile
      when 7 then dic = nil
      end
      # конец выполнение выбранного пункта меню
    end until num == 0 || dic == nil
  end  # конец условия когда текущий словарь выбран

end until num == 0  # конец цикла выбора в меню