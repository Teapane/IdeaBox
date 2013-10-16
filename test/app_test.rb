gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/app'
require 'rack/test'

class AppTest < Minitest::AppTest
  include Rack::Test::Methods

  def app
    IdeaBoxApp
  end

  def test_hello
    get "/"
    assert_equal "Hello World", last_response.body
  end

  def test_create_new_idea
    post "/", {idea: {title: "exercise", description: "Sign up for stick fighting classes"}}
    idea = IdeaStore.all.first
    assert_equal "exercise", idea.title
    assert_equal "sign up for...", idea.description
  end

end 
