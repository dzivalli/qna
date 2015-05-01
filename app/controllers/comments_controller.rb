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
    klass = URI.parse(request.path).path.split('/')[1].singularize
    if params["#{klass}_id"].to_i > 0
      @commentable = klass.classify.safe_constantize.find_by_id params["#{klass}_id"] if klass.classify.safe_constantize
    else
      render nothing: true, status: :not_acceptable
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
