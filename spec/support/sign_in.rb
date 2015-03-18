module SignIn
  def log_in
    before do
      @user = create(:user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
    end
  end
end