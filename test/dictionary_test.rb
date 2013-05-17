require 'test_helper'

class DictionaryTest < Test::Unit::TestCase
  # include Spout::Tests

  include Spout::Tests::JsonValidation
  include Spout::Tests::VariableTypeValidation
  # include Spout::Tests::DomainExistenceValidation
  include Spout::Tests::DomainFormat
end
