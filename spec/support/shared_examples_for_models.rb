shared_examples 'votable' do
  it { is_expected.to have_many(:user_votes).dependent(:destroy) }

  describe '.vote!' do
    let(:user) { create(:user) }
    subject(:votable) { create(described_class.to_s.underscore.to_sym) }

    context 'when action down' do
      context 'when there are no previous votes' do
        before { votable.vote!(user, 'down') }

        it 'decreases votes by 1' do
          expect(votable.votes).to eq -1
        end

        it 'sets positive attr of question_vote to false' do
          expect(votable.user_votes.find_by(user: user).positive).to be_falsey
        end
      end

      context 'when previous vote was positive' do
        before do
          votable.vote!(user, 'up')

          votable.vote!(user, 'down')
        end

        it 'deletes vote' do
          expect(votable.user_votes.find_by(user: user)).to be_falsey
        end

        it 'increase votes count by -1' do
          expect(votable.votes).to eq 0
        end
      end
    end

    context 'when action up' do
      context 'when there are no previous votes' do
        before { votable.vote!(user, 'up') }

        it 'increases votes by 1' do
          expect(votable.votes).to eq 1
        end

        it 'sets positive attr of user_votes to true' do
          expect(votable.user_votes.find_by(user: user).positive).to be_truthy
        end
      end

      context 'when previous vote was negative' do
        before do
          votable.vote!(user, 'down')

          votable.vote!(user, 'up')
        end

        it 'deletes vote' do
          expect(votable.user_votes.find_by(user: user)).to be_falsey
        end

        it 'increase votes count by 1' do
          expect(votable.votes).to eq 0
        end
      end
    end
  end

  describe '.check_vote?' do
    let(:user) { create(:user) }
    subject(:votable) { create(described_class.to_s.underscore.to_sym) }

    it 'returns true if vote positive and action "up"' do
      votable.user_votes.create user: user, positive: true

      expect(votable.check_vote?(user, 'up')).to be_truthy
    end

    it 'returns true if vote negative and action "down"' do
      votable.user_votes.create user: user, positive: false

      expect(votable.check_vote?(user, 'down')).to be_truthy
    end

    it 'returns false if there is no votes' do
      expect(votable.check_vote?(user, 'up')).to be_falsey
      expect(votable.check_vote?(user, 'down')).to be_falsey
      expect(votable.check_vote?(user)).to be_falsey
    end
  end
end

shared_examples 'attachable' do
  it { is_expected.to have_many(:attachments).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:attachments).allow_destroy(true) }
end