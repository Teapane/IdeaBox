require_relative 'idea_box'
#require_relative 'user'
#require_relative 'login_management'

# Create a sign up form
  # Allow users to enter username and password
  # Store that information in the YAML
  # Password needs to be encrypted (Bcrypt)
# Scope ideas to signed in user
  # env['warden'].user.ideas
  # I should not be able to see other users ideas
  # Search also needs to be scoped
# Logout
# Secure all routes
  # As an unauthenticated user, I can not see any ideas
# Oh and testing

class IdeaBox < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'
  configure :development do
    register Sinatra::Reloader  
  end

  not_found do
    erb :error
  end

   get '/' do
     #redirect '/login' unless env['warden'].authenticated?
     erb :index, locals: {ideas: IdeaStore.all.sort, idea: Idea.new}
     #erb :index, locals: {ideas: env['warden'].user.ideas.sort, idea: Idea.new}
   end

  post '/' do 
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end  


  get '/search' do
    tagged_ideas = IdeaStore.search(params[:search_tag])
     erb :search, locals: {tagged_ideas: tagged_ideas}
  end

  get '/lookup' do
    lookup_ideas = IdeaStore.lookup(params[:lookup])
    erb :lookup, locals: {lookup_ideas: lookup_ideas}
  end

  get '/tags' do
    idea_tags = IdeaStore.all_tags
    erb :tags, locals: {idea_tags: idea_tags, ideas: IdeaStore}
  end
  
   get '/login/?' do
    erb :login
   end
  
   post '/login/?' do
    env['warden'].authenticate!
    redirect "/"
   end

   get '/searchday' do
    search_by_day = params[:idea][:search_day]
    erb :searchday, locals: {search_by_day: search_by_day, ideas: IdeaStore.all.sort}
   end

    get '/groups' do
    matching_ideas = IdeaStore.find_by_group(params[:groups])
    erb :groups, locals: {matching_ideas: matching_ideas}
  end
end
