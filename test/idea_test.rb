gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/idea_box/idea'

class IdeaTest < Minitest::Test
   def test_basic_idea
    idea = Idea.new("title"       => "b-fast",
                    "description" => "biscuits n' gravy",
                    "id"          => "1")
    assert_equal "b-fast", idea.title
    assert_equal "biscuits n' gravy", idea.description
    assert_equal "1", idea.id
  end

  def test_it_has_a_hash_of_data_as_input
    idea = Idea.new("title"       => "b-fast",
                    "description" => "biscuits n' gravy",
                    "id"          => "1")
    expected = {    "title"       => "b-fast",
                    "description" => "biscuits n' gravy",
                    "rank"       => 0 }
    assert_equal expected, idea.to_h
    idea.like!
    expected2 = {   "title"       => "b-fast",
                    "description" => "biscuits n' gravy",
                    "rank"       => 1 }
    assert_equal expected2, idea.to_h
  end

  def test_it_starts_with_rank_zero_if_not_liked
    idea = Idea.new
    assert_equal 0, idea.rank
  end

  def test_the_like_method_increases_the_count
    idea = Idea.new
    assert_equal 0, idea.rank
    idea.like!
    assert_equal 1, idea.rank
  end
 
end 
