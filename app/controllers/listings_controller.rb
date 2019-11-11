# frozen_string_literal: true

class ListingsController < ApplicationController
  include PaginationConcern
  include SortingConcern

  load_and_authorize_resource :phase

  def create
    if current_user.cf_admin?
      create_listings
    else
      render json: { notice: t("lettings.failure.letting_deny") }
    end
  end

  def update
    listing = Listing.find(params[:id])

    errors = success = nil
    if listing && !listing.live?
      listing.update(owner: params[:owner])
      success = t(".success", plot_number: listing.plot)
    else
      errors = listing&.live? ? t(".live", plot_number: listing.plot) : t(".failure")
    end

    redirect_to session[:adminlistings].redirect_url,
                notice: success,
                alert: errors
  end

  def destroy
    listing = Listing.find(params[:id])

    errors = success = nil
    if listing && !listing.live?
      plot = listing.plot
      listing.destroy
      success = t(".success", plot_number: plot)
    else
      errors = listing&.live? ? t(".live", plot_number: listing.plot) : t(".failure")
    end

    redirect_to session[:adminlistings].redirect_url,
                notice: success,
                alert: errors
  end

  protected

  def listing_params
    params.require(:phase_lettings).permit(%i[owner list phase_id])
  end

  def create_listings
    BulkPlots::CreateListingsService.call(nil, params: listing_params) do |_, plots, errors|
      redirect_to session[:adminlistings].redirect_url,
                  notice: plots.any? ? success_notice(plots) : nil,
                  alert: errors
    end
  end

  def success_notice(listed_plots)
    if listed_plots.count == 1
      t(".success_one", plot_number: listed_plots.first)
    else
      t(".success", plot_numbers: listed_plots.to_sentence)
    end
  end
end
