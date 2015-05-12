class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question

  def index
    respond_with(@answers = @question.answers)
  end

  def show
    respond_with(@answer = Answer.find(params[:id]))
  end

  def create
    @answer = Answer.create answer_params
    respond_with @question, @answer
  end

  private

  def find_question
    @question = Question.find params[:question_id]
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end