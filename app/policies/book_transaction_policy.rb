class BookTransactionPolicy < ApplicationPolicy
  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  def index?
    librarian? || member?
  end

  def show?
    librarian? || member?
  end

  def return?
    librarian?
  end

  class Scope < Scope
    def resolve
      if user.librarian?
        scope.all
      elsif user.member?
        scope.where(user: user)
      end
    end
  end
end
