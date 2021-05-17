# frozen_string_literal: true

module Admin
  class DashboardController < ApplicationController
    skip_authorization_check

    # rubocop:disable Metrics/MethodLength
    def show
      screen = :show

      if current_user.charts?
        screen = :charts
        initialse_charts
      else
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

      render screen
    end
    # rubocop:enable Metrics/MethodLength

    private

    # rubocop:disable LineLength
    # rubocop:disable Metrics/AbcSize
    def notifications_scope
      if current_user.cf_admin?
        Notification.where.not(subject: I18n.t("resident_snag_mailer.notify.new_notification"))
                    .where.not(subject: I18n.t("resident_notification_mailer.notify.update_subject"))
                    .where.not(subject: I18n.t("resident_notification_mailer.notify.old"))
                    .includes(:sender, :send_to)
      else
        Notification.accessible_by(current_ability)
                    .where(sender_id: current_user.id)
                    .where.not(subject: I18n.t("resident_snag_mailer.notify.new_notification"))
                    .where.not(subject: I18n.t("resident_notification_mailer.notify.update_subject"))
                    .where.not(subject: I18n.t("resident_notification_mailer.notify.old"))
                    .includes(:sender, :send_to)
      end
    end
    # rubocop:enable LineLength
    # rubocop:enable Metrics/AbcSize

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

    # rubocop:disable Metrics/LineLength
    def initialse_charts
      @selections = User::Filter.new(current_user)
      @developers = Developer.all.order(:company_name)
      @divisions = Developer.find_by(id: @selections.developer)
                            &.divisions&.order(:division_name) || []
      @developments = Division.find_by(id: @selections.division)&.developments&.order(:name) ||
                      (@selections.developer != 0 ? Developer.find_by(id: @selections.developer).all_developments : [])
      @phases = Development.find_by(id: @selections.development)&.phases&.order(:name) || []
    end
    # rubocop:enable Metrics/LineLength
  end
end
