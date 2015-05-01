class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_votable, only: [:edit, :update, :destroy, :up, :down]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.includes(:attachments, :comments).find params[:id]
    @answers = @question.answers.includes(:attachments, :comments).best_first
    @answer = Answer.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = Question.new question_params.merge(user: current_user)
    if @question.save
      PrivatePub.publish_to "/questions", question: @question
      redirect_to @question, notice: 'Question was created'
    else
      flash[:notice] = 'Please, check input data'
      render 'new'
    end
  end

  def edit
    @question.attachments.build
    render layout: false
  end

  def update
    if current_user.owns? @question
      @question.update question_params
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

  def find_votable
    @question = Question.find params[:id]
  end
end
