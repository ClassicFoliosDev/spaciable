# frozen_string_literal: true

class Crm < ApplicationRecord
  belongs_to :developer
  has_one :access_token

  delegate :token, to: :access_token
  delegate :refresh_token, to: :access_token
end
