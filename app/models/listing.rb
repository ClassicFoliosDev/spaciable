# frozen_string_literal: true

class Listing < ApplicationRecord
  belongs_to :plot, optional: false
  belongs_to :lettings_account

  delegate :number, to: :plot, prefix: true

  enum owner: %i[
    homeowner
    admin
  ]

  def live?
    account?
  end

  # Retrieve all homeowner listings associated with the given plots
  def self.homeowner_listings(plots)
    Listing.where(plot_id: plots.pluck(:id), owner: :homeowner)
  end

  # Retrieve all developer listings associated with the given plots
  def self.admin_listings(plots)
    Listing.where(plot_id: plots.pluck(:id), owner: :admin)
  end

  def account?
    lettings_account.present?
  end

  def belongs_to?(owner)
    account? && lettings_account.belongs_to?(owner)
  end

  def belongs_to
    return "Nobody" unless live?

    lettings_account.belongs_to
  end

  # Update a listing
  # rubocop:disable Rails/Presence
  def self.update?(owner, params, &block)
    listing = Listing.find_by(plot_id: params[:plot_id].to_i)
    error = "Cannot find plot #{params[:plot_id]}" unless listing
    error ||= "#{owner} does not have an account" unless owner.lettings_account

    if error.blank?
      listing.reference = params[:reference]
      listing.other_ref = params[:other_ref]
      listing.lettings_account_id = owner.lettings_account.id
      error = "Failed to update listing for plot #{params[:plot_id]}" unless listing.save
    end

    block.call error.blank?, error.present? ? error : nil
  end
  # rubocop:enable Rails/Presence
end
