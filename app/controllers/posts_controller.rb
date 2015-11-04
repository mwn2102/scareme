class PostsController < ApplicationController
  before_action :set_post, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
    # @posts = Post.all.order(created_at: :desc) 
    @posts = Post.paginate(:page => params[:page], :per_page => 4).order(created_at: :desc) 
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
