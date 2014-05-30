require 'test_helper'

class DictionaryTest < Test::Unit::TestCase
  include Spout::Tests

  VALID_UNITS = ['minute', 'arousals', 'days', 'drinks', 'oxygen desaturation events', 'bottles', 'glasses', 'cans', 'cups', 'cigarettes', 'years', 'naps', 'days from index date', 'seconds', 'percent', 'score', 'millimeters of mercury', 'cigars', 'bowls', 'day', 'hour', 'beats per minute', 'replacements', 'kohms', 'replacements', 'year', 'grade', 'cigarettes per day', 'contacts', 'pack years', 'drinks per day', 'stage shifts', 'second', 'events per hour', 'liter', 'milligram per deciliter', 'index', 'kilograms', 'kilogram', 'centimeter', 'kilogram per square meter', 'number of events', 'central apnea events', 'obstructive apnea events', 'hypopnea events','millimeters','']

  def assert_units(units, msg = nil)
    full_message = build_message(msg, "? invalid units. Valid types: #{VALID_UNITS.join(', ')}", units)
    assert_block(full_message) do
      VALID_UNITS.include?(units)
    end
  end

  Dir.glob("variables/**/*.json").each do |file|
    if ['numeric','integer'].include?(json_value(file, :type))
      define_method("test_units: "+file) do
        assert_units json_value(file, :units)
      end
    end
  end

  Dir.glob("forms/**/*.json").each do |file|
    define_method("test_json: "+file) do
      assert_valid_json file
    end
  end

  Dir.glob("forms/**/*.json").each do |file|
    define_method("test_form_name_match: "+file) do
      assert_equal file.gsub(/^.*\//, '').gsub('.json', '').downcase, (begin JSON.parse(File.read(file))["id"] rescue nil end)
    end
  end

  def test_form_name_uniqueness
    files = Dir.glob("forms/**/*.json").collect{|file| file.split('/').last.downcase }
    assert_equal [], files.select{ |f| files.count(f) > 1 }.uniq
  end

  def assert_form_existence(item, msg = nil)
    form_names = Dir.glob("forms/**/*.json").collect{|file| file.split('/').last.to_s.downcase.split('.json').first}

    result = begin
      (form_names | JSON.parse(File.read(item))["forms"]).size == form_names.size
    rescue JSON::ParserError
      false
    end

    full_message = build_message(msg, "One or more forms referenced by ? does not exist.", item)
    assert_block(full_message) do
      result
    end
  end

  Dir.glob("variables/**/*.json").each do |file|
    if (not [nil, ''].include?(JSON.parse(File.read(file))["forms"]) rescue false)
      define_method("test_form_exists: "+file) do
        assert_form_existence file
      end
    end
  end

end
