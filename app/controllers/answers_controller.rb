class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: :show
  before_action :find_question
  before_action :find_votable, only: [:edit, :update, :destroy, :choice, :up, :down]

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new answer_params.merge(question: @question, user: current_user)
    if @answer.save
      @answer_new = Answer.new
      @answer_new.attachments.build
      PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json(include: :attachments)
      render nothing: true
    else
      @answer
    end
  end


  def edit
    @answer.attachments.build
    render layout: false
  end

  def update
    if current_user.owns? @answer
      if @answer.update answer_params
        render json: @answer.to_json(include: :attachments)
      else
        render json: @answer.errors.full_messages, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @answer.destroy if current_user.owns? @answer
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
end
