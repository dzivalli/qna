class Reputation
  def self.calculate(data)
    user, controller, action = data
    amount =
      case action
        when 'up'
          controller == 'answers' ? 1 : 2
        when 'down'
          controller == 'answers' ? -1 : -2
        when 'create'
          if controller == 'answers'
            answer = user.answers.last
            additional =  if answer.question.user == user && answer.question.answers.count == 1 then 3
                          elsif answer.question.user == user && answer.question.answers.count > 1 then 2
                          elsif answer.question.answers.count == 1 then 1
                          else 0
                          end
            1 + additional
          else 0
          end
        when 'choice'
          controller == 'answers' ? 3 : 0
      end
    user.increment! :reputation, by = amount
  end
end