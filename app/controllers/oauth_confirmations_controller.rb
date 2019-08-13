class OauthConfirmationsController < Devise::ConfirmationsController
  def new; end

  def create
    @email = confirm_params[:email]
    password = Devise.friendly_token[0, 20]
    @user = User.new(email: @email, password: password, password_confirmation: password)

    if @user.save!
      @user.send_confirmation_instructions
    else
      flash.now[:alert] = 'Enter valid email !'
      render :new
    end
  end

  private

  def after_confirmation_path_for(resource_name, user)
    # user.save!  #Validation failed: Email can't be blank, Password can't be blank
    user.authorizations.create(auth)
    sign_in user, event: :authentication
  end

  def confirm_params
    params.permit(:email)
  end

  def resource
    @resource ||= User.new
  end

  def auth
    @auth ||= { provider: session[:provider], uid: session[:uid] }
  end
end
