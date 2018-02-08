require 'minitest/autorun'
require 'minitest/pride'
require './multilinguist.rb'

class TestMultilinguist < MiniTest::Test

  def test_language_in
    person = Multilinguist.new
    assert_equal('es', person.language_in('mexico'))
  end

end
