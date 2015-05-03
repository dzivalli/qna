class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question
  before_action :find_votable, only: [:edit, :update, :destroy, :choice, :up, :down]
  before_action :check_owner, only: [:update, :destroy]

  include Voted

  layout false, only: :edit

  respond_to :html, :js
  respond_to :json, only: :create

  def new
    respond_with(@answer = Answer.new)
  end

  def create
    @answer = Answer.create answer_params.merge(question: @question, user: current_user)
    respond_with @question, @answer do |format|
      format.json { publish if @answer.valid? }
    end
  end

  def edit
    @answer.attachments.build
  end

  def update
    @answer.update answer_params
    respond_with @answer
  end

  def destroy
    respond_with @answer.destroy
  end

  def choice
    @answer.best! if current_user.owns? @question
  end


  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def find_question
    @question = Question.find params[:question_id]
  end

  def find_votable
    @answer = Answer.find params[:id]
  end

  def check_owner
    not_found unless current_user.owns? @answer
  end

  def publish
    PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json(include: :attachments)
  end
end
