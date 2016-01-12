require 'test_helper'
require 'colorize'

class DictionaryTest < Minitest::Test
  # This line includes all default Spout Dictionary tests
  include Spout::Tests

  # This line provides access to @variables, @forms, and @domains
  # iterators that can be used to write custom tests
  include Spout::Helpers::Iterators

  # These tests can be removed when spout v0.10.0 is released as it will be included by default
  @variables.each do |variable|
    define_method("test_no_more_than_255_display_name: "+variable.path) do
      assert_operator 255, :>=, variable.display_name.size
    end
  end

  VALID_UNITS = ['minute', 'arousals', 'drinks', 'oxygen desaturation events', 'bottles', 'glasses', 'cans', 'cups', 'cigarettes', 'years', 'naps', 'days from index date', 'seconds', 'percent', 'score', 'millimeters of mercury', 'cigars', 'bowls', 'day', 'hour', 'beats per minute', 'replacements', 'kohms', 'replacements', 'year', 'grade', 'cigarettes per day', 'contacts', 'pack years', 'drinks per day', 'stage shifts', 'events per hour', 'liter', 'milligram per deciliter', 'index', 'kilograms', 'kilogram', 'centimeter', 'kilogram per square meter', 'number of events', 'central apnea events', 'obstructive apnea events', 'hypopnea events']

  @variables.select{|v| ['numeric','integer'].include?(v.type)}.each do |variable|
    define_method("test_units: "+variable.path) do
      message = "\"#{variable.units}\"".colorize( :red ) + " invalid units.\n" +
                "             Valid types: " +
                VALID_UNITS.sort.collect{|u| u.inspect.colorize( :white )}.join(', ')
      assert VALID_UNITS.include?(variable.units), message
    end
  end

  USED_UNITS = @variables.collect{|v| v.units}.uniq.compact

  def test_no_unused_units
    assert_equal [], VALID_UNITS - USED_UNITS
  end

end
