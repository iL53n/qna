class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_subscription, only: :destroy

  authorize_resource

  def create
    @subscription = @question.subscriptions.create(user: current_user)
  end

  def destroy
    @subscription.destroy
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_subscription
    @subscription = current_user.subscriptions.find(params[:id])
  end
end
