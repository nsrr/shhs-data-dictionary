require 'test_helper'

class DictionaryTest < Minitest::Test
  include Spout::Tests

  VALID_UNITS = ['minute', 'arousals', 'days', 'drinks', 'oxygen desaturation events', 'bottles', 'glasses', 'cans', 'cups', 'cigarettes', 'years', 'naps', 'days from index date', 'seconds', 'percent', 'score', 'millimeters of mercury', 'cigars', 'bowls', 'day', 'hour', 'beats per minute', 'replacements', 'kohms', 'replacements', 'year', 'grade', 'cigarettes per day', 'contacts', 'pack years', 'drinks per day', 'stage shifts', 'second', 'events per hour', 'liter', 'milligram per deciliter', 'index', 'kilograms', 'kilogram', 'centimeter', 'kilogram per square meter', 'number of events', 'central apnea events', 'obstructive apnea events', 'hypopnea events','millimeters','minutes','']

  Dir.glob("variables/**/*.json").each do |file|
    if ['numeric','integer'].include?(json_value(file, :type))
      define_method("test_units: "+file) do
        units = json_value(file, :units)
        message = "#{units} invalid units. Valid types: #{VALID_UNITS.join(', ')}"
        assert VALID_UNITS.include?(units), message
      end
    end
  end

end
