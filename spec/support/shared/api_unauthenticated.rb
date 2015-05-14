shared_examples 'unauthenticated' do
  context 'when user is unauthenticated' do
    it 'returns unauthorized error without access token' do
      do_request
      expect(response).to have_http_status :unauthorized
    end

    it 'returns unauthorized error with invalid access token' do
      do_request(access_token: 'sdfsfs')
      expect(response).to have_http_status :unauthorized
    end
  end
end