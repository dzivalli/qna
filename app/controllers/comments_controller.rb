class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_commentable

  def new
    if user_signed_in?
      comment = @commentable.comments.build
      @comment_decorator = CommentDecorator.new(comment)
    end
  end

  def create
    if user_signed_in?
      comment = @commentable.comments.build comment_params
      comment.save
      @comment_decorator = CommentDecorator.new(comment)
    end
  end

  private

  def find_commentable
    @commentable = Comment.find_parent(params) if Comment.find_parent(params)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
