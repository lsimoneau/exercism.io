require './test/test_helper'
require './test/fixtures/fake_curricula'

require 'exercism/named'
require 'exercism/exercise'
require 'exercism/assignment'
require 'exercism/trail'
require 'exercism/curriculum'

class CurriculumTest < MiniTest::Unit::TestCase

  attr_reader :curriculum
  def setup
    @curriculum = Curriculum.new('./test/fixtures')
    curriculum.add FakeRubyCurriculum.new
  end

  def test_curriculum_takes_a_path
    assert_equal './test/fixtures', curriculum.path
  end

  def test_find_exercise_in_trail
    ex = Exercise.new('ruby', 'one')
    assert_equal ex, curriculum.in('ruby').find('one')
  end

  def test_get_assignment_from_trail
    assignment = curriculum.in('ruby').assign('one')
    assert_equal './test/fixtures/ruby/one', assignment.path
  end

  def test_get_assignment_from_curriculum
    exercise = Exercise.new('ruby', 'one')
    assignment = curriculum.assign(exercise)
    assert_equal './test/fixtures/ruby/one', assignment.path
  end
end

class ConvenienceCurriculumTest < MiniTest::Unit::TestCase
  attr_reader :curriculum
  def setup
    super
    @curriculum = Curriculum.new('./test/fixtures')
    @curriculum.add FakeRubyCurriculum.new
    @curriculum.add FakeGoCurriculum.new
    Exercism.instance_variable_set(:@trails, nil)
    Exercism.instance_variable_set(:@languages, nil)
  end

  def teardown
    super
    Exercism.instance_variable_set(:@trails, nil)
    Exercism.instance_variable_set(:@languages, nil)
  end

  def test_languages
    Exercism.stub(:curriculum, curriculum) do
      assert_equal [:go, :ruby], Exercism.languages
    end
  end

  def test_trails
    Exercism.stub(:curriculum, curriculum) do
      ruby = Exercise.new('ruby', 'one')
      go = Exercise.new('go', 'one')
      assert_equal [ruby, go], Exercism.trails.map {|t| t.exercises.first}
    end
  end
end

