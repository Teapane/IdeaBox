class Idea
  attr_accessor :updated_at, :created_at, :group, :tags

  attr_reader :title, :description, :rank, :id

  def initialize(attributes = {})
    @title       = attributes["title"]
    @description = attributes["description"]
    @rank        = attributes["rank"] || 0
    @id          = attributes["id"]
    @tags        = attributes["tags"] || []
    @updated_at  = attributes["updated_at"] ||= Time.now
    @created_at  = attributes["created_at"] ||= Time.now
    @group       = attributes["group"] ||= "no group"
  end

  def save
    IdeaStore.create("title"      => title, 
                    "description" => description, 
                    "rank"        => rank, 
                    "tags"        => tags, 
                    "created_at"  => created_at, 
                    "updated_at"  => updated_at, 
                    "group"       => group)
  end

  def database
    Idea.database
  end

  def save
  database.transaction do
    database['ideas'] ||= []
    database['ideas'] << {"title"       => title, 
                          "description" => description, 
                          "rank"        => rank, 
                          "tags"        => tags,
                          "created_at"  => created_at,
                          "updated_at"  => updated_at,
                          "group"       => group}
  end
end

 def save
  IdeaStore.create(to_h)
 end

 def keyword?(keyword)
   title.include?(keyword) || description.include?(keyword) || tags.include?(keyword) || group.include?(keyword)
 end

 def to_h
  {
    "title"       => title,
    "description" => description,
    "rank"        => rank,
    "tags"        => tags,
    "updated_at"  => updated_at,
    "created_at"  => created_at,
    "group"       => group
   }
 end

 def day_of_week
    if created_at.wday == 0
      "Sunday"
    elsif created_at.wday == 1
      "Monday"
    elsif created_at.wday == 2
      "Tuesday"
    elsif created_at.wday == 3
      "Wednesday"
    elsif created_at.wday = 4
      "Thursday"
    elsif created_at.wday = 5
      "Friday"
    else
      "Saturday"
  end
end

 def like!
  @rank += 1
 end

 def <=>(other)
  other.rank <=> rank
 end 

end 
 
