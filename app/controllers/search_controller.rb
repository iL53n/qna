class SearchController < ApplicationController
  def result
    @params = search_params

    if @params[:q] == ''
      flash.now[:alert] = 'Search field is empty'
    else
      @result = Services::Search.call(@params)
    end
  end

  private

  def search_params
    params.permit(:q, :resource)
  end
end