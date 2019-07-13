module Voted
  # ToDo: Покрыть тестами контроллер
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_resource, only: %i[up down]
  end

  def up
    @resource.up_rating
    render json: { id: @resource.id, rating: @resource.rating }
  end

  def down
    @resource.down_rating
    render json: { id: @resource.id, rating: @resource.rating }
  end

  private

  def set_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end
end
