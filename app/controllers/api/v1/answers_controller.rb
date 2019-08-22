class Api::V1::AnswersController < Api::V1::BaseController
  load_and_authorize_resource

  def show
    render json: answer
  end

  private

  def answer
    @answer ||= Answer.find(params[:id])
  end

  # def question
  #   @question ||= Question.find(params[:question_id])
  # end
end
