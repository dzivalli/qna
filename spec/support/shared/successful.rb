shared_examples 'successful' do
  it 'returns success' do
    expect(response).to be_success
  end
end