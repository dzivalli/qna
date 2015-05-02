class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable

  def new
    comment = @commentable.comments.build
    @comment_decorator = CommentDecorator.new(comment)
  end

  def create
    comment = @commentable.comments.build comment_params
    comment.save
    @comment_decorator = CommentDecorator.new(comment)
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
