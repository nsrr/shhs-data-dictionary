require 'test_helper'

class DictionaryTest < Test::Unit::TestCase
  include Spout::Tests

  # include Spout::Tests::JsonValidation
  # include Spout::Tests::VariableTypeValidation
  # include Spout::Tests::DomainExistenceValidation
  # include Spout::Tests::DomainFormat

  def test_variable_uniqueness
    files = Dir.glob("variables/**/*.json").collect{|file| file.split('/').last }
    assert_equal [], files.select{ |f| files.count(f) > 1 }.uniq
  end

end
