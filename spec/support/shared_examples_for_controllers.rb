shared_examples 'unauthorized for question vote' do
  it 'does not change vote counter', format: :json do
    expect(question.votes).to eq 0
  end

  it 'returns status 401', format: :json do
    expect(response).to have_http_status :unauthorized
  end
end

shared_examples 'returnable json object with question votes' do
  it 'returns json object with votes', format: :json do
    expect(response.body).to eq question.votes.to_s
  end
end

shared_examples 'unauthorized for answer vote' do
  it 'does not change vote counter', format: :json do
    expect(answer.votes).to eq 0
  end

  it 'returns status 401', format: :json do
    expect(response).to have_http_status :unauthorized
  end
end

shared_examples 'returnable json object with answer votes' do
  it 'returns json object with votes', format: :json do
    expect(response.body).to eq answer.votes.to_s
  end
end