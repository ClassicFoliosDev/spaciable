# frozen_string_literal: true

module Admin
  class DashboardController < ApplicationController
    skip_authorization_check

    def show
      @notifications = notifications_scope.order(updated_at: :desc).limit(5)
      @faqs = faqs_scope.order(updated_at: :desc).limit(5)
      docs = documents_scope.order(updated_at: :desc).limit(5)
      appliances = []
      if current_user.cf_admin?
        appliances = Appliance.all.includes(:appliance_manufacturer)
                              .order(updated_at: :desc).limit(5)
      end
      @documents = DocumentLibraryService.call(docs, appliances).first(5)
    end

    private

    def notifications_scope
      if current_user.cf_admin?
        Notification.all.includes(:sender, :send_to)
      else
        Notification.accessible_by(current_ability)
                    .where(sender_id: current_user.id).includes(:sender, :send_to)
      end
    end

    def documents_scope
      if current_user.cf_admin?
        Document.all
      else
        Document.accessible_by(current_ability)
                .where(documentable_id: current_user.permission_level_id,
                       documentable_type: current_user.permission_level_type)
      end
    end

    def faqs_scope
      @faqs = if current_user.cf_admin?
                Faq.all
              else
                Faq.accessible_by(current_ability)
                   .where(faqable_id: current_user.permission_level_id,
                          faqable_type: current_user.permission_level_type)
              end
    end
  end
end
