class SearchController < ApplicationController
  def result
    @params = search_params

    if q_empty?
      flash.now[:alert] = 'Search field is empty'
    else
      @result = Services::Search.call(@params)
    end
  end

  private

  def q_empty?
    @params[:q] == ''
  end

  def search_params
    params.permit(:q, :resource)
  end
end