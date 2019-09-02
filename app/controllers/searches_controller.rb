class SearchesController < ApplicationController

  RESOURCE = %w[All Question Answer Comment User]

  def result
    @resource = search_params[:resource]
    @q_text = search_params[:q]

    @q_text == '' ? flash.now[:alert] = 'Search field is empty' : return_result
  end

  private

  def search_params
    params.permit(:q, :resource)
  end

  def return_result
    @resource == 'All' ? @result = search(ThinkingSphinx) : @result = search(@resource.constantize)
  end

  def search(resource)
    resource.search @q_text
  end
end