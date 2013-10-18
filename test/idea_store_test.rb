ENV['RACK_TEST'] = "true"
gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/idea_box/idea_store'
require './lib/idea_box/idea'
require 'yaml/store'
require 'pry'

class IdeaStoreTest <Minitest::Test

  def setup
    IdeaStore.database
    IdeaStore.create("title" => "Is this thing on?", "description" => "dog", "tags" => "poo")
    IdeaStore.create("title" => "Yo?", "description" => "cat", "tags" => "sand")
    IdeaStore.create("title" => "hi", "tags"  => "Why?", "description" => "hi Austen")
  end

  def teardown
    IdeaStore.destroy_database
  end

  def test_the_database_exists
    assert_kind_of Psych::Store, IdeaStore.database
  end

  def test_it_creates_a_new_idea_and_stores_in_database
    result = IdeaStore.database.transaction {|db| db["ideas"].first}
    assert_equal "Is this thing on?", result["title"]
  end

  def test_it_finds_by_id
    result = IdeaStore.find(1)
    assert_equal 1, result.id
    assert_kind_of Idea, result
    assert_equal "Yo?", result.title
  end

  def test_it_can_update_an_idea
    assert_equal "Yo?", IdeaStore.find(1).title
    IdeaStore.update(1, "title" => "Yo")
    result = IdeaStore.find(1)
    assert_equal "Yo", result.title
  end

  def test_it_leaves_others_unchanged_when_updating_an_idea
    IdeaStore.update(1, "title" => "Is this thing on?")
    result = IdeaStore.find(1)
    assert_equal "Is this thing on?", result.title
  end

  def test_it_finds_by_tag
    #IdeaStore.search("Why?")
    result = IdeaStore.search("Why?")
    #assert_equal 2, result.id
    assert_equal 1, result.count
  end
 
 def test_it_can_lookup_by_phrase
  result = IdeaStore.lookup("hi Austen")
  assert_equal 1, result.count
end

  #def test_it_can_update_an_idea
end
