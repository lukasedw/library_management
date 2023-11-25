class AuthorPolicy < ApplicationPolicy
  def create?
    librarian?
  end

  def update?
    librarian?
  end

  def destroy?
    librarian?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
