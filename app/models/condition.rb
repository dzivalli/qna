class Condition
  def self.from_params(params)
    @params = params
    @condition_hash = {}
    @search_string = @params[:q] || ''

    return @search_string if check_for_search_everywhere?
    return raw_search_string_for_questions if @params[:conditions] == 'questions'

    if @params[:conditions].is_a?(String)
      conditions_from_string
    else
      conditions_from_array
    end

    { conditions: @condition_hash }
  end


  private

  def self.check_for_search_everywhere?
    @params.key?(:conditions) && @params[:conditions].include?('everywhere') || !@params.key?(:conditions)
  end

  def self.conditions_from_string
    @condition_hash = { @params[:conditions].to_sym => @search_string }
  end

  def self.raw_search_string_for_questions
    "@body #{@search_string} | @title #{@search_string}"
  end

  def self.conditions_from_array
    @params[:conditions].each { |value| @condition_hash[value.to_sym] = @search_string }
  end
end