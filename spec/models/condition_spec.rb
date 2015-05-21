require 'rails_helper'

describe Condition do
  it 'returns only search word if there no conditions' do
    expect(Condition.from_params(q: 'word', conditions: 'everywhere')).to eq 'word'
  end

  it 'returns conditions hash if there is array of conditions' do
    expect(Condition.from_params(q: 'word', conditions: ['comments', 'answers'])).to eq({conditions: {comments: 'word',
                                                                                                       answers: 'word'}})
  end

  it 'returns conditions hash if there is one condition' do
    expect(Condition.from_params(q: 'word', conditions: 'answer')).to eq({conditions: {answer: 'word'}})
  end

  it 'returns question only fields if condition is questions' do
    expect(Condition.from_params(q: 'word', conditions: 'questions')).to eq("@body word | @title word")
  end
end