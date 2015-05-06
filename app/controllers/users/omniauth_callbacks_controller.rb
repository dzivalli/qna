class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth_login

  def facebook
  end

  def twitter
  end

  private

  def oauth_login
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
    else
      session["omniauth_data"] = request.env["omniauth.auth"].slice(:provider, :uid)
      redirect_to new_user_registration_url
    end
  end
end