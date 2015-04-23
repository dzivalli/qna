shared_examples 'unauthorized for question' do
  it 'does not change vote counter', format: :json do
    expect(question.votes).to eq 0
  end

  it 'returns status 401', format: :json do
    expect(response).to have_http_status :unauthorized
  end
end

shared_examples 'unauthorized for answer' do
  it 'does not change vote counter', format: :json do
    expect(answer.votes).to eq 0
  end

  it 'returns status 401', format: :json do
    expect(response).to have_http_status :unauthorized
  end
end

shared_examples 'forbidden for question' do
  it 'does not change vote counter', format: :json do
    expect(question.votes).to eq 0
  end

  it 'returns status 403' do
    expect(response).to have_http_status :forbidden
  end
end

shared_examples 'forbidden for answer' do
  it 'does not change vote counter', format: :json do
    expect(answer.votes).to eq 0
  end

  it 'returns status 403' do
    expect(response).to have_http_status :forbidden
  end
end
