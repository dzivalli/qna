class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question

  def index
    respond_with(@answers = @question.answers)
  end

  def show
    respond_with(@answer = Answer.find(params[:id]))
  end

  private

  def find_question
    @question = Question.find params[:question_id]
  end
end