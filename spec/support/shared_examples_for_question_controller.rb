shared_examples 'unauthorized' do
  it 'does not change vote counter', format: :json do
    expect(question.votes).to eq 0
  end

  it 'returns status 401' do
    expect(response).to have_http_status :unauthorized
  end
end

shared_examples 'returnable json object with votes' do
  it 'returns json object with votes', format: :json do
    expect(response.body).to eq question.votes.to_s
  end
end