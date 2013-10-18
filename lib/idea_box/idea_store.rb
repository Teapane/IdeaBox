require 'yaml/store'

class IdeaStore

def self.all
  ideas = []
  raw_ideas.each_with_index do |data, i|
    ideas << Idea.new(data.merge("id" => i))
  end
  ideas
end

def self.find(id)
  raw_idea = find_raw_idea(id)
  Idea.new(raw_idea.merge("id" => id))
end

def self.database
  return @database if @database

  if ENV['RACK_ENV'] == "test"
    @database ||= YAML::Store.new("db/test_ideabox")
  else
    @database ||= YAML::Store.new('db/ideabox')
  end
  @database.transaction do
    @database['ideas'] ||= []
  end
  @database
end

def self.create(data)
  database.transaction do
    database['ideas'] << data
  end
end

  def self.raw_ideas
  database.transaction do |db|
    db['ideas'] || []
    end
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.destroy_database
    database.transaction do |db|
      db["ideas"] = []
    end
  end

  def self.find_raw_idea(id)
   database.transaction do
    database['ideas'].at(id)
  end
 end

 def self.update(id, data)
  database.transaction do
    database['ideas'][id] = data
  end
end 

 # def self.search(search_tag)
 #  database.transaction do 
 #    ideas = database["ideas"].select do |idea|
 #      if idea["tags"]
 #        idea["tags"].include?(search_tag)
 #      end
 #    end
 #    ideas.map! {|i| Idea.new(i)}
 #  end  
  #database["ideas"].select do |idea|
    #idea["tags"].include?(search_tag)
  #end
    #{|tag| searching_tags.gsub(",","").split(" ").include?(tag)} 
#   end
#  end
# end

 def self.group_by_tag
  all.group_by{|idea| idea.tags}
 end

 def self.search(search_tag)
    all.select { |idea| idea.to_h["tags"].include? search_tag }
  end

 def self.lookup(keyword) #This method is only returning the first part of the loop
   all.select do |idea|
    #if idea.to_h["title"] 
     idea.to_h["title"].include?(keyword)||
    #elsif idea.to_h["description"] 
     idea.to_h["description"].include?(keyword) ||
    #elsif idea.to_h["tags"] 
     idea.to_h["tags"].include?(keyword) 
  end
 end
end
