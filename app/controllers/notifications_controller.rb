class NotificationsController < ApplicationController
  before_action :find_notification, only: :destroy
  before_action :check_authorization
  before_action :find_question

  respond_to :js

  def create
    @notification = @question.notifications.create user: current_user
    respond_with @notification
  end

  def destroy
    respond_with @notification.destroy
  end

  private

  def find_question
    @question = Question.find params[:question_id]
  end

  def find_notification
    @notification = Notification.find params[:id]
  end

  def check_authorization
    authorize @notification || :notification
  end
end
