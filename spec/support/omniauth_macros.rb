module OmniauthMacros
  def twitter_mock
    OmniAuth.config.mock_auth[:twitter] = {
        provider: 'twitter',
        uid: '123545',
        info: {
            name: 'name',
        }
    }
  end

  def facebook_mock
    OmniAuth.config.mock_auth[:facebook] = {
        provider: 'facebook',
        uid: '123545',
        info: {
            email: 'email@email.ru',
        }
    }
  end
end