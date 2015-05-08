class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user && record.user == user
  end

  def edit?
    update?
  end

  def destroy?
    user && record.user == user
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

end
