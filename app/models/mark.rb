# frozen_string_literal: true

# A Mark is applied to a record to record who made the last change to it
class Mark < ApplicationRecord
  include RoleEnum
  belongs_to :markable, polymorphic: true

  # If this mark was made my a CF Admin and the current user is NOT a
  # CF Admin, then show "CF Admin", otherwise show the full name of the
  # user that made the mark
  def marker
    return "CF Admin" if cf_admin? && !RequestStore.store[:current_user].cf_admin?
    username
  end
end
