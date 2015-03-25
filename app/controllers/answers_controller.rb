class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question
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
    if @answer.belongs_to?(current_user)
      @question.change_best_if(@answer)
      @answer.destroy
    end

  end

  def choice
    @question.update(answer: @answer) if @answer.belongs_to?(current_user)
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
