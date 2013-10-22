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
    @database ||= if ENV['RACK_ENV'] == "test"
    YAML::Store.new("db/test_ideabox")
   else
    YAML::Store.new('db/ideabox')
   end
  end

  def self.create(data)
    transaction { database_ideas << data }
  end

  def self.raw_ideas
    transaction { database_ideas || [] }
  end

  def self.delete(position)
    transaction { database['ideas'].delete_at(position) }
  end

  def self.destroy_database
    transaction { database["ideas"] = [] }
  end

  def self.find_raw_idea(id)
    transaction { database_ideas.at(id) }
  end

  def self.update(id, data)
    transaction { database_ideas[id] = data }
  end 

  def self.transaction
    database.transaction { yield }
  end

  def self.database_ideas
    database['ideas']
  end

  def self.group_by_tag
    all.group_by{|idea| idea.tags}
  end

  def self.search(search_tag)
    all.select { |idea| idea.to_h["tags"].include? search_tag }
  end

  def self.lookup(keyword) #This method is only returning the first part of the loop
   all.select do |idea|
    idea.keyword?(keyword)
   end
  end

  def self.all_tags
    all_tags = []
    all.each do |idea|
      idea.tags.split(", ").each do |tag|
        all_tags << tag
      end
    end
    all_tags.uniq
    #all.collect {|idea| idea.tags.split(",")}
  end

  def self.collected_tags
    all_tags.each_with_object({}) do |tag, hash|
      hash[tag] = all.select do |idea|
        idea.to_h["tags"].include?(tag)
      end
    end
  end
end
