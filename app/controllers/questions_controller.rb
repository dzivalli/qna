class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_votable, only: [:edit, :update, :destroy, :up, :down]
  before_action :check_owner, only: [:update, :destroy]

  layout false, only: :edit

  respond_to :html, :js

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@question = Question.includes(:attachments, :comments).find(params[:id]))
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    @question = Question.new question_params.merge(user: current_user)
    PrivatePub.publish_to "/questions", question: @question if @question.save
    respond_with @question
  end

  def edit
    @question.attachments.build
  end

  def update
    @question.update question_params
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def find_votable
    @question = Question.find params[:id]
  end

  def check_owner
    not_found unless current_user.owns? @question
  end
end
