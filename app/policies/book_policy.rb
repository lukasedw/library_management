class BookPolicy < ApplicationPolicy
  def create?
    librarian?
  end

  def update?
    librarian?
  end

  def destroy?
    librarian?
  end

  def borrow?
    member?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
