class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable

  respond_to :js

  def new
    respond_with(@comment_decorator = CommentDecorator.new(@commentable.comments.build))
  end

  def create
    @comment_decorator = CommentDecorator.new(@commentable.comments.create comment_params)
    authorize @comment_decorator.comment
    respond_with @comment_decotator if @comment_decorator.valid?
  end

  private

  def find_commentable
    klass = URI.parse(request.path).path.split('/')[1].singularize
    if params["#{klass}_id"].present?
      @commentable = klass.classify.safe_constantize.try :find_by_id, params["#{klass}_id"]
    else
      not_authorized
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
