class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource

  def index
    render json: questions
  end

  def show
    render json: question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)

    if @question.save
      render json: question, status: :created
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if question.update(question_params)
      render json: question, status: :created
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if question.destroy
      render json: {}, status: :ok
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: [:name, :url],
                                     reward_attributes: [:title, :image])
  end

  def question
    @question ||= Question.with_attached_files.find(params[:id])
  end

  def questions
    @questions ||= Question.all
  end
end