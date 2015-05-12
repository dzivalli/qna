class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@question = Question.find(params[:id]))
  end

  def create
    @question = Question.create question_params
    respond_with @question
  end

  private

  def question_params
    params.require(:question).permit(:body, :title)
  end
end