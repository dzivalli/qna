class SearchController < ApplicationController
  def index
    @questions = Question.search Condition.from_params(params)
    respond_with @questions, location: search_index_path
  end
end
