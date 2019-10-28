# frozen_string_literal: true

class AccessToken < ApplicationRecord
  # Create and save an AccessToken.
  def self.create(instance, &block)
    error = nil
    pr_token = instance

    unless pr_token.is_a? OAuth2::AccessToken
      PlanetRent.token instance do |token, pr_error|
        error = pr_error
        pr_token = token
      end
    end

    unless error
      token = AccessToken.new pr_token.to_hash.slice :access_token, :refresh_token, :expires_at
      error = "Failed to save token" unless token.save
    end

    block.call token, error
  end

  # check if the token is out of date.  If it has expired then obtain a new
  # one and update the object with the details
  def refresh!
    if expired?
      PlanetRent.refresh_token(to_hash) do |new_token, error|
        unless error
          update_attributes access_token: new_token.token,
                            refresh_token: new_token.refresh_token,
                            expires_at: new_token.expires_at
          save
        end
      end
    end

    self
  end

  # has the token expired?
  def expired?
    expires_at < Time.now.to_i
  end

  # get the attributes of this object sans the id as a hash
  def to_hash
    attributes.to_hash.except("id")
  end
end
