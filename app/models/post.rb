class Post < ActiveRecord::Base
  acts_as_votable
  belongs_to :user
  has_many :comments, dependent: :destroy
  belongs_to :category
  default_scope -> { order(created_at: :desc) }
  self.per_page = 4
  
  #This method removes the default scope before the query
  def self.random_top_story
        Post.unscoped {
          Post.order("RANDOM()")
        }
  end
  
  def self.top_story
        Post.unscoped {
          Post.order(cached_votes_up: :desc)
        }
  end
  
  def self.search(params)
    posts = Post.where("title like ? or content like ?", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
    posts
    # ['name like ?', "%#{search}%"]
  end
end
