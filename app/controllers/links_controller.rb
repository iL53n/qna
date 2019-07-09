class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :load_link

  def destroy
    resource = @link.linkable

    if current_user.author_of?(resource)
      @link.destroy
    else
      head :forbidden
    end
  end

  private

  def load_link
    @link = Link.find(params[:id])
  end
end
