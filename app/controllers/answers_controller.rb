class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: %i[create destroy update best]
  before_action :load_question, only: :create
  before_action :load_answer, only: %i[destroy show update best]
  after_action :publish_answer, only: [:create]

  authorize_resource

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def best
    @question = @answer.question

    @answer.set_best
  end

  def destroy
    @answer.destroy
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def publish_answer
    return if @answer.errors.any?

    attachments = @answer.files.map do |file|
      { id: file.id,
        filename: file.filename.to_s,
        url: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
      }
    end

    ActionCable.server.broadcast(
        "answers_question_#{@question.id}",
        answer: @answer,
        rating: @answer.rating,
        links: @answer.links,
        attachments: attachments
    )
  end
end
