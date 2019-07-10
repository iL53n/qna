class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy update best]
  before_action :load_question, only: :create
  before_action :load_answer, only: %i[destroy show update best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def best
    @question = @answer.question

    @answer.set_best if current_user.author_of?(@question)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
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
end
