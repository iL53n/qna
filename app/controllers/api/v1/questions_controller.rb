class Api::V1::QuestionsController < Api::V1::BaseController
  # load_and_authorize_resource

  def index
    render json: questions
  end

  def show
    render json: question
  end

  private

  def question
    @question ||= Question.with_attached_files.find(params[:id])
  end

  def questions
    @questions ||= Question.all
  end
end