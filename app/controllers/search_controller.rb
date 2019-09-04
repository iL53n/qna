class SearchController < ApplicationController
  def result
    @params = search_params

    if q_empty?
      flash.now[:alert] = 'Search field is empty'
    else
      @result = call_service
    end
  end

  private

  def q_empty?
    @params[:q] == ''
  end

  def call_service
    Services::Search.call(@params)
  end

  def search_params
    params.permit(:q, :resource)
  end
end