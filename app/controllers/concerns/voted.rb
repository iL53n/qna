module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_resource, only: %i[up cancel down]
  end

  def up
    @resource.up_rating
    render_rating
  end

  def cancel
    @resource.cancel_vote
    render_rating
  end

  def down
    @resource.down_rating
    render_rating
  end

  private

  def set_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def render_rating
    render json: { id: @resource.id, rating: @resource.rating }
  end
end
