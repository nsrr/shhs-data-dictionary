# frozen_string_literal: true

require "test_helper"

class DictionaryTest < Minitest::Test
  # This line includes all default Spout Dictionary tests.
  include Spout::Tests

  # This line provides access to @variables, @forms, and @domains iterators
  # iterators that can be used to write custom tests.
  include Spout::Helpers::Iterators

  # Example 1: Create custom tests to show that `integer` and `numeric`
  # variables have a valid unit type.
  VALID_UNITS = [
    nil, "", "microvolts squared per hertz", "hertz", "arousals",
    "car accidents", "miles", "beats per minute", "bottles", "bowls", "cans",
    "centimeters", "central apnea events", "cigarettes", "cigarettes per day",
    "cigars", "cups", "days", "days from index date", "drinks",
    "drinks per day", "events per hour", "glasses", "hours",
    "hypopnea events", "index", "kilograms", "kilograms per square meter",
    "liters", "milligrams per deciliter", "millimeters",
    "millimeters of mercury", "minutes", "naps", "number of events",
    "obstructive apnea events", "oxygen desaturation events", "pack years",
    "percent", "seconds", "stage shifts", "years",
    "seconds from start of recording", "milliseconds", "milliseconds squared"]
  @variables.select { |v| %w(numeric integer).include?(v.type) }.each do |variable|
    define_method("test_units: #{variable.path}") do
      message = "\"#{variable.units}\"".red + " invalid units.\n" +
                "             Valid types: " +
                VALID_UNITS.sort_by(&:to_s).collect { |u| u.inspect.white }.join(", ")
      assert VALID_UNITS.include?(variable.units), message
    end
  end

  # Example 2: Create custom tests to show that variables have 2 or more labels.
  # @variables.select { |v| %w(numeric integer).include?(v.type) }.each do |variable|
  #   define_method("test_at_least_two_labels: #{variable.path}") do
  #     assert_operator 2, :<=, variable.labels.size
  #   end
  # end

  # Example 3: Create regular Ruby tests
  # You may add additional tests here
  # def test_truth
  #   assert true
  # end
end
