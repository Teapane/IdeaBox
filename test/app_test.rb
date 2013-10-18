ENV['RACK_ENV'] = 'test'

gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/app'
require './lib/app'
require 'rack/test'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    IdeaBox
  end

  def test_it_exists
    assert IdeaBox
  end

  def test_it_moves_to_index
    get '/'
    assert last_response.ok?
    assert_equal 200, last_response.status
  end

  def test_form_displays_properly
    get "/"
    assert (last_response.body =~ /Existing Ideas/)
    assert (last_response.body =~ /IdeaBox/)
    assert (last_response.body =~ /tag/)
    assert (last_response.body =~ /Your Idea/)
    assert (last_response.body =~ /submit/)
    assert (last_response.body =~ /description/)
  end

  def test_create_new_idea
    post "/", {idea: {title: "exercise", description: "Sign up for stick fighting classes"}}
    idea = IdeaStore.all.first
    assert_equal "exercise", idea.title
    assert_equal "Sign up for stick fighting classes", idea.description
  end

  def teardown
    IdeaStore.destroy_database
  end
end 
