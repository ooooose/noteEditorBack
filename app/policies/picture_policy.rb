class PicturePolicy < ApplicationPolicy
  class Scope
    def resolve
      scope.all
    end
  end

  # ユーザーがログインしているかどうかを確認
  def general_check?
    user.present?
  end

  # ログイン中のユーザーに紐づくデータのみアクセス許可
  def record_owner?
    record.user.id == user.id
  end

  def create?
    general_check? 
  end

  def show?
    general_check?
  end

  def update?
    general_check? && record_owner?
  end

  def destroy?
    general_check? && (record_owner? || user.admin?)
  end
end
