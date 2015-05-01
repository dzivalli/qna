class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true

  def self.find_parent(params)
    parent_id = params.keys.detect { |k,_| k.match(/_id$/) }
    if parent_id
      klass = parent_id.to_s.split('_id').first.capitalize
      klass.safe_constantize.find_by_id params[parent_id] if klass.safe_constantize
    end
  end
end
