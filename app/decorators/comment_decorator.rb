class CommentDecorator
  attr_reader :comment

  def initialize(comment)
    @comment = comment
  end

  def form
    "#{parent_data_id} .comment-form"
  end

  def error_field
    "#{parent_data_id} .errors"
  end

  def comment_field
    "#{parent_data_id} .comments"
  end

  def publish_url
    "/#{parent_class.pluralize}/#{parent_id}/comments"
  end

  def method_missing(method, *args, &block)
    comment.send method, *args, &block
  end

  private

  def parent_data_id
    "[data-#{parent_class}-id='#{parent_id}']"
  end

  def parent_id
    comment.commentable.id
  end

  def parent_class
    comment.commentable.class.name.downcase
  end
end