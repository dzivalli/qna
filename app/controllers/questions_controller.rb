class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:edit, :update, :destroy, :show]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers.best_first
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new question_params.merge(user: current_user)
    if @question.save
      redirect_to @question, notice: 'Question was created'
    else
      flash[:notice] = 'Please, check input data'
      render 'new'
    end
  end

  def edit
  end

  def update
    @question.update question_params
  end

  def destroy
    if @question.user == current_user
      @question.destroy
      redirect_to questions_path
    else
      redirect_to @question
    end

  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = Question.find params[:id]
  end
end
