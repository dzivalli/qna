class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question
  before_action :find_answer, only: [:edit, :update, :destroy, :choice]

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new answer_params.merge(question: @question, user: current_user)
    if @answer.save
      @answer_new = Answer.new
      @answer_new.attachments.build
      respond_to do |format|
        format.json { render json: @answer }
      end
    else
      respond_to do |format|
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end


  def edit
    @answer.attachments.build
    render layout: false
  end

  def update
    if current_user.owns? @answer
      @answer.update answer_params
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

  def find_answer
    @answer = Answer.find params[:id]
  end
end
