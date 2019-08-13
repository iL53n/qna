module OmniauthMacros
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.downcase.to_sym] = OmniAuth::AuthHash.new({
        provider: provider.downcase,
        uid: '1235456',
        info: { email: 'user@mock.com' },
        credentials: { token: 'mock_token', secret: 'mock_secret' }
    })
  end

  def mock_auth_twitter
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
       provider: 'Twitter',
       uid: '1235456',
       info: { email: nil },
       credentials: { token: 'mock_token', secret: 'mock_secret' }
   })
  end

  def invalid_mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.downcase.to_sym] = :invalid_credentials
  end

  def silence_omniauth
    previous_logger = OmniAuth.config.logger
    OmniAuth.config.logger = Logger.new("/dev/null")
    yield
  ensure
    OmniAuth.config.logger = previous_logger
  end
end