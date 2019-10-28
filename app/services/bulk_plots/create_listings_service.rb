# frozen_string_literal: true

module BulkPlots
  class CreateListingsService < BulkPlots::Base
    def self.call(plot, params: {}, &block)
      service = superclass.call(plot, params: params, service: self)

      if block_given?
        service.save
        block.call(service, service.successful_numbers, service.errors)
      end

      service
    end

    def save
      return no_numbers_error if bulk_attributes.empty?

      bulk_attributes.map { |attrs| create_listing(attrs) }.any?
    end

    def successful_numbers
      @successful_numbers ||= []
    end

    protected

    BulkCreateListingModel = Class.new(Listing) do
      delegate :model_name, to: :Listing
      attr_accessor :range_from, :range_to, :list, :phase_id
    end

    def collection_model
      BulkCreateListingModel
    end

    # rubocop:disable Metrics/MethodLength
    def create_listing(attrs)
      # get the plot from the number and phase
      attrs[:plot_id] =
        Plot.select(:id)
            .find_by(number: attrs[:number],
                     phase_id: attrs[:phase_id])&.id

      # create a new Listing using only owner and plot_id
      new_listing = Listing.new(attrs.slice(:owner, :plot_id))

      # Listing does not have a :number attribute around
      # which to group errors so add one dynamically
      new_listing.class.module_eval { attr_accessor :number }
      new_listing.number = attrs[:number]

      saved = false
      begin
        saved = new_listing.save
      # just add a custom error if its a duplicate
      rescue ActiveRecord::RecordNotUnique
        new_listing.errors.add(:base, :listed, message: "already listed")
      ensure
        successful_numbers << attrs[:number] if saved
        @errors << new_listing unless saved
      end

      saved
    end
  end
  # rubocop:enable Metrics/MethodLength
end
