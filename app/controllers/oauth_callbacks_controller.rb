class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_user, only: %i[github facebook twitter vkontakte]

  def github; end

  def facebook; end

  def twitter; end

  def vkontakte; end

  private

  def set_user
    auth = request.env['omniauth.auth']
    unless auth
      redirect_to new_user_session_path, alert: 'Authentication failed, please try again.'
      return
    end

    @user = User.find_for_oauth(auth)

    if @user&.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      session[:provider] = auth.provider
      session[:uid] = auth.uid
      redirect_to new_user_confirmation_path
    end
  end
end
