# frozen_string_literal: true

module Homeowners
  class DevelopmentMessagesController < Homeowners::BaseController
    include SortingConcern
    before_action :setup

    def index; end

    def create
      return unless @plot.enable_development_messages?

      @message = new_message(message_params)
      if @message.save
        setup
        render :index
      else
        alert = t(".failure")
        render :index, alert: alert
      end
    end

    private

    def new_message(message_params)
      DevelopmentMessage.create(
        message_params.merge(
          resident: current_resident,
          development: @plot.development
        )
      )
    end

    def setup
      @messages = @plot.development.development_messages.primary
                       .last_three_months.includes(:resident)
      @message = DevelopmentMessage.new
    end

    def message_params
      params.require(:development_message).permit(
        :subject, :content, :parent_id
      )
    end
  end
end
