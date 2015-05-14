require 'rails_helper'

RSpec.describe Reputation do
  describe '#calculate' do
    let(:user) { create :user }

    context 'when controller is Questions' do
      controller = 'questions'

      it 'update user reputation by 2 if action .up' do
        expect { Reputation.calculate(user, [controller, 'up']) }.to change(user, :reputation).by 2
      end

      it 'update user reputation by -2 if action .down' do
        expect { Reputation.calculate(user, [controller, 'down']) }.to change(user, :reputation).by -2
      end
    end

    context 'when controller is Answers' do
      controller = 'answers'

      it 'update user reputation by 1 if action .up' do
        expect { Reputation.calculate(user, [controller, 'up']) }.to change(user, :reputation).by 1
      end

      it 'update user reputation by -1 if action .down' do
        expect { Reputation.calculate(user, [controller, 'down']) }.to change(user, :reputation).by -1
      end

      it 'update user reputation by 3 if action .choice' do
        expect { Reputation.calculate(user, [controller, 'choice']) }.to change(user, :reputation).by 3
      end

      context 'when action .create with additional conditions' do
        let(:question) { create :question }
        let(:answer) { create :answer, question: question, user: user }

        it 'updates reputation by 1 if user isnt question owner and answer isnt first' do
          create(:answer, question: question)
          answer

          expect { Reputation.calculate(user, [controller, 'create']) }.to change(user, :reputation).by 1
        end

        it 'updates reputation by 1 + 1 if user is first' do
          answer
          expect { Reputation.calculate(user, [controller, 'create']) }.to change(user, :reputation).by 2
        end

        it 'updates reputation by 1 + 3 if user is first and he is question owner' do
          answer
          user.questions << question

          expect { Reputation.calculate(user, [controller, 'create']) }.to change(user, :reputation).by 4
        end

        it 'updates reputation by 1 + 2 if user isnt first but he is question owner' do
          user.questions << question
          create(:answer, question: question)
          answer

          expect { Reputation.calculate(user, [controller, 'create']) }.to change(user, :reputation).by 3
        end
      end
    end
  end
end