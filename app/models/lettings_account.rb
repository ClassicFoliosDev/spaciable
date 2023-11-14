# frozen_string_literal: true

# rubocop:disable Rails/HasManyOrHasOneDependent
class LettingsAccount < ApplicationRecord
  has_many :listings
  belongs_to :access_token, dependent: :destroy
  belongs_to :accountable, polymorphic: true

  enum management: %i[
    self_managed
    management_service
    agency
  ]

  enum authorisation_status: %i[
    pending
    authorised
  ]

  # create a new letting account
  def self.create(params, &block)
    account = LettingsAccount.new params
    block.call account, account.save
  end

  # Does the user/resident have an account
  def self.account?(owner)
    LettingsAccount.find_by(owner_type: owner.class.to_s,
                            owner_id: owner.id)
                   .present?
  end

  def self.restricted?(management)
    management == "management_service"
  end

  # Authorise a lettings account.  This involves creating a token
  # from the provided code.
  def authorise(code)
    AccessToken.create code do |token, error|
      unless error
        self.access_token_id = token.id
        self.authorisation_status = :authorised
        error = "Failed to authorise" unless save
      end

      return error
    end
  end

  # rubocop:disable Metrics/MethodLength
  # Authorise an admin. The authorizing user information is
  # retrieved from PlanetRent using the token, and the email checked
  # the user's email to ensure the correct Planet Rent correct user has
  # authorised the spaciable account
  def authorise_admin(code, user)
    PlanetRent.token code do |pr_token, error|
      return error if error

      PlanetRent.user_info(pr_token) do |user_info, uerror|
        return uerror if uerror

        if user_info["email"] != user.email
          return "Incorrect authorisation.  " \
                 "The authorising account must have the email " \
                 "#{user.email}"
        end
      end

      AccessToken.create pr_token do |token, prerror|
        return prerror if prerror

        self.access_token_id = token.id
        self.authorisation_status = :authorised
        return !save ? "Failed to authorise" : nil
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # Does this account belong to the user/resident
  def belongs_to?(owner)
    accountable_type == owner.class.to_s && accountable_id == owner.id
  end

  # Find the owner of this account
  def belongs_to
    return "Nobody" unless accountable_id

    accountable_type.constantize.find(accountable_id).to_s
  end
end
# rubocop:enable Rails/HasManyOrHasOneDependent
