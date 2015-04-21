shared_examples 'vote up' do
  context 'when there are no previous votes' do
    before { votable.vote_up!(user) }

    it 'increases votes by 1' do
      expect(votable.votes).to eq 1
    end

    it 'sets positive attr of user_votes to true' do
      expect(votable.user_votes.find_by(user: user).positive).to be_truthy
    end
  end

  context 'when previous vote was negative' do
    before do
      votable.vote_down!(user)

      votable.vote_up!(user)
    end

    it 'deletes vote' do
      expect(votable.user_votes.find_by(user: user)).to be_falsey
    end

    it 'increase votes count by 1' do
      expect(votable.votes).to eq 0
    end
  end
end

shared_examples 'vote down' do
  context 'when there are no previous votes' do
    before { votable.vote_down!(user) }

    it 'decreases votes by 1' do
      expect(votable.votes).to eq -1
    end

    it 'sets positive attr of question_vote to false' do
      expect(votable.user_votes.find_by(user: user).positive).to be_falsey
    end
  end

  context 'when previous vote was positive' do
    before do
      votable.vote_up!(user)

      votable.vote_down!(user)
    end

    it 'deletes vote' do
      expect(votable.user_votes.find_by(user: user)).to be_falsey
    end

    it 'increase votes count by -1' do
      expect(votable.votes).to eq 0
    end
  end
end

shared_examples 'negative vote' do
  it 'returns true if vote negative' do
    votable.user_votes.create user: user, positive: false

    expect(votable.vote_negative?(user)).to be_truthy
  end

  it 'returns false if vote positive' do
    votable.user_votes.create user: user, positive: true

    expect(votable.vote_negative?(user)).to be_falsey
  end

  it 'returns false if there is no votes' do
    expect(votable.vote_negative?(user)).to be_falsey
  end
end

shared_examples 'positive vote' do
  it 'returns true if vote positive' do
    votable.user_votes.create user: user, positive: true

    expect(votable.vote_positive?(user)).to be_truthy
  end

  it 'returns false if vote negative' do
    votable.user_votes.create user: user, positive: false

    expect(votable.vote_positive?(user)).to be_falsey
  end

  it 'returns false if there is no votes' do
    expect(votable.vote_positive?(user)).to be_falsey
  end
end