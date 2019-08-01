class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_resource, only: :create
  after_action :publish_comment, only: :create

  def create
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_resource
    if params[:question_id]
      @resource = Question.find(params[:question_id])
    else
      @resource = Answer.find(params[:answer_id])
    end
  end

  def publish_comment
    return if @comment.errors.any?

    question_id = @resource.is_a?(Question) ? @resource.id : @resource.question.id

    ActionCable.server.broadcast(
        "comments_question_#{question_id}",
        comment: @comment,
        email: @comment.user.email,
        created_at: @comment.created_at
    )
  end
end

