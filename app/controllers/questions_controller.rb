class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.includes(:attachments).find params[:id]
    @answers = @question.answers.best_first
    @answer = Answer.new
    @question.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
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
    if current_user.owns? @question
      @question.update! question_params
      @question.attachments.build
    end
  end

  def destroy
    if current_user.owns? @question
      @question.destroy
      redirect_to questions_path
    else
      redirect_to @question
    end

  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def find_question
    @question = Question.find params[:id]
  end
end
