# frozen_string_literal: true
class User
  module NoPasswordRequired
    def password_required?
      false
    end
  end
end
