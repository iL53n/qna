class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  check_authorization unless :devise_controller?
  # skip_authorization_check

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.js { head :forbidden }
      format.json { render json: exception.message, status: :forbidden }
    end
  end

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
