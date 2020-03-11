# frozen_string_literal: true

class Perk
  include ActiveModel::Model

  attr_accessor :developer, :first_name, :last_name, :email, :postcode
  attr_accessor :group, :reference, :expire_date, :access_type
end
