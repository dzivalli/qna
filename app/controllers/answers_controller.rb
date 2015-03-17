class AnswersController < ApplicationController
  before_action :find_question
  before_action :find_answer, only: [:edit, :update, :destroy]

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new answer_params.merge(question: @question)
    if @answer.save
      redirect_to @question, notice: 'Answer was added'
    else
      flash[:notice] = 'Please, fill in body area'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @answer.update answer_params
      redirect_to @question
    else
      render 'edit'
    end
  end

  def destroy
    redirect_to @question if @answer.destroy
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
