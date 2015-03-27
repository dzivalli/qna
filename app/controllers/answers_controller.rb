class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question, except: :choice
  before_action :find_answer, only: [:edit, :update, :destroy, :choice]

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new answer_params.merge(question: @question, user: current_user)
    @answer.save
  end

  def edit
  end

  def update
    @answer.update answer_params if @answer.belongs_to?(current_user)
  end

  def destroy
    @answer.destroy if @answer.belongs_to?(current_user)
  end

  def choice
    @answer.best! if @answer.belongs_to?(current_user)
  end


  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find params[:question_id]
  end

  def find_answer
    @answer = Answer.find params[:id]
  end
end
