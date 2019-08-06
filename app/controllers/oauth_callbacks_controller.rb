class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    set_user('GitHub')
  end

  def facebook
    set_user('Facebook')
  end

  def set_user(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to new_user_session_path
    end
  end
end
