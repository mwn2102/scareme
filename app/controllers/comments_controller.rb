class CommentsController < ApplicationController
      before_action :authenticate_user!
      before_action :correct_user, only: [:destroy]
      
    def create
        @post = Post.find(params[:post_id])
        @comment = @post.comments.build(comment_params)
        @comment.user_id = current_user.id
        if @comment.save
            redirect_to @post
        end
    end
    
    def destroy
        @post = Post.find(params[:post_id])
        @comment = Comment.find(params[:id])
        @comment.destroy
        redirect_to @post
    end
    
    private
        
        def comment_params
            params.require(:comment).permit(:body)
        end
        
        def correct_user
          @comment = Comment.find(params[:id])
          if @comment.user != current_user
            redirect_to posts_path
            flash[:danger] = "Access denied"
          end
        end
    
    
end
