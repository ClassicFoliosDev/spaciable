# frozen_string_literal: true
module Admin
  class DashboardController < ApplicationController
    skip_authorization_check

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Style/MethodLength
    def show
      if current_user.cf_admin?
        @notifications = Notification.all
                                     .includes(:sender, :send_to)
                                     .order(updated_at: :desc).limit(5)
        @documents = Document.all.order(updated_at: :desc).limit(5)
        @faqs = Faq.all.order(updated_at: :desc).limit(5)
      else
        @notifications = Notification.where(sender_id: current_user.permission_level_id)
                                     .includes(:sender, :send_to)
                                     .order(updated_at: :desc).limit(5)
        @documents = Document.where(documentable_id: current_user.permission_level_id)
                             .order(updated_at: :desc).limit(5)
        @faqs = Faq.where(faqable_id: current_user.permission_level_id)
                   .order(updated_at: :desc).limit(5)
      end
    end
    # rubocop:enable Style/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end
