class UserPolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.joins(:user).where(id: user.id )
    end

    private

    attr_reader :user, :scope
  end

  # ユーザーがログインしているかどうかを確認
  def general_check?
    user.present?
  end

  # ログイン中のユーザーに紐づくデータのみアクセス許可
  def record_owner?
    record.user.id == user.id
  end
  
  def show?
    general_check?
  end

  def update?
    general_check? && record_owner?
  end

  def destroy?
    general_check? && general_check? && (record_owner? || user.admin?)
  end
end