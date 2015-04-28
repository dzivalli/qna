class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question

  def new
    if user_signed_in?
      @comment = @question.comments.build
    end
  end

  def create
    if user_signed_in?
      @comment = @question.comments.build comment_params
      @comment.save
    end
  end

  private

  def find_question
    @question = Question.find params[:question_id]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
