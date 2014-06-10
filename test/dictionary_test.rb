require 'test_helper'
require 'colorize'

class DictionaryTest < Minitest::Test
  # This line includes all default Spout Dictionary tests
  include Spout::Tests

  # This line provides access to @variables, @forms, and @domains
  # iterators that can be used to write custom tests
  include Spout::Helpers::Iterators

   VALID_UNITS = ["", "arousals", "beats per minute", "bottles", "bowls", "cans", "centimeters",
    "central apnea events", "cigarettes", "cigarettes per day", "cigars", "cups", "days",
    "days from index date", "drinks", "drinks per day", "events per hour", "glasses", "hours",
    "hypopnea events", "index", "kilograms", "kilograms per square meter", "liters",
    "milligrams per deciliter", "millimeters", "millimeters of mercury", "minutes", "naps",
    "number of events", "obstructive apnea events", "oxygen desaturation events", "pack years",
    "percent", "seconds", "stage shifts", "years"]

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
