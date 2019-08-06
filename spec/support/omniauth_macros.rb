module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
        provider: 'github',
        uid: '1235456',
        info: { email: 'user@mock.com' },
        credentials: { token: 'mock_token', secret: 'mock_secret' }
    })

    # OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    #     provider: 'facebook',
    #     uid: '1235456',
    #     info: { email: 'user@mock.com' },
    #     credentials: { token: 'mock_token', secret: 'mock_secret' }
    # })
  end

  def invalid_mock_auth_hash
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    # OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
  end
end