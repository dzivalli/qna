class Reputation
  def self.calculate(user, data)
    @controller, action = data
    @user = user

    amount =
      case action
        when 'up' then voting_karma
        when 'down' then voting_karma * -1
        when 'create' then create_karma
        when 'choice' then choice_karma
      end

    user.increment! :reputation, amount
  end

  private

  def self.voting_karma
    @controller == 'answers' ? 1 : 2
  end

  def self.choice_karma
    @controller == 'answers' ? 3 : 0
  end

  def self.create_karma
    @controller == 'answers' ? with_additional : 0
  end

  def self.with_additional
    answer = @user.answers.last
    additional =  if answer.question.user == @user && answer.question.answers.count == 1 then 3
                  elsif answer.question.user == @user && answer.question.answers.count > 1 then 2
                  elsif answer.question.answers.count == 1 then 1
                  else 0
                  end
    1 + additional
  end
end