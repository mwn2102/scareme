class PostsController < ApplicationController
  before_action :set_post, except: [:index, :new, :create, :search]
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
    @categories = Category.all
    if params[:category].blank?
      if params[:filter] == "random"
        @posts = Post.random_top_story.paginate(page: params[:page])
      elsif params[:filter] == "top"
        @posts = Post.top_story.paginate(page: params[:page])
      else  
        @posts = Post.paginate(page: params[:page])
      end
    else  
      @category_id = Category.find_by(area: params[:category]).id
      @posts = Post.where(category_id: @category_id).paginate(page: params[:page])
      #removed this scope because now using default scopes: .order(created_at: :desc)
    end

  end

  def new
    @post = Post.new
  end
  
  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end
  
  def update
    @post.update(post_params)
    if @post.save
      redirect_to @post
      flash[:notice] = "Post successfully updated"
    end
  end
  
  def destroy
    @post.destroy
    redirect_to posts_path
  end
  
  def upvote
    @post.upvote_by current_user
    redirect_to :back
  end

  def downvote
    @post.downvote_from current_user
    redirect_to :back
  end
  
  def search
    @posts = Post.search(params).paginate(page: params[:page])
  end
  
  private
    def set_post
      @post = Post.find(params[:id])
    end
    
    def post_params
      params.require(:post).permit(:title, :content, :category_id)
    end
    
    def correct_user
      @post = Post.find(params[:id])
      if @post.user != current_user
        redirect_to posts_path
        flash[:danger] = "Access denied"
      end
    end
end
