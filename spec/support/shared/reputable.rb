shared_examples 'reputable' do
  it 'calls update reputation after save/update' do
    expect(Reputation).to receive(:calculate).exactly(2).times

    obj = build described_class.name.downcase.to_sym
    obj.controller_data = 'controller data'

    obj.save
    obj.update votes: 1
  end
end