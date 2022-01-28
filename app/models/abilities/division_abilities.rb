# frozen_string_literal: true

module Abilities
  module DivisionAbilities
    def division_abilities(division, developer_id)
      crud_users(role: :division_admin, id: division, model: "Division")

      division_notifications(division, developer_id)
      division_faqs(division, developer_id)
      division_contacts(division, developer_id)
      division_documents(division, developer_id)
      division_videos(division)
      division_calendar
      read_divisions(developer_id, division)
      division_build_progress(division)
    end

    private

    def division_videos(division)
      polymorphic_abilities Video, :videoable do
        type "Division", id: division, actions: :manage
      end

      cannot %i[update destroy], Video, override: true
    end

    def division_build_progress(division)
      polymorphic_abilities BuildSequence, :build_sequenceable do
        type "Division", id: division, actions: :manage
        type "Global", id: Global.root.id, actions: :read
      end
      can :read, Global
    end

    def read_divisions(developer_id, division)
      can :read, Developer, id: developer_id
      can :read, Development, division_id: division
      can :read, Division, id: division
    end

    def division_notifications(division, developer)
      polymorphic_abilities Notification, :send_to do
        type "Division", id: division, actions: :manage
        type "Developer", id: developer, actions: :read
      end

      cannot :manage, Notification, send_to_all: true
    end

    def division_faqs(division, developer)
      polymorphic_abilities Faq, :faqable do
        type "Division", id: division, actions: :manage
        type "Developer", id: developer, actions: :read
      end
    end

    def division_contacts(division, developer)
      polymorphic_abilities Contact, :contactable do
        type "Division", id: division, actions: :manage
        type "Developer", id: developer, actions: :read
        type "Phase", id: Phase.where(division_id: division).lazy.pluck(:id), actions: :manage
      end
    end

    def division_documents(division, developer)
      polymorphic_abilities Document, :documentable do
        type "Developer", id: developer, actions: :read

        actions :manage do
          type "Division", id: division
          type "UnitType", id: UnitType.where(division_id: division).lazy.pluck(:id)
          type "Phase", id: Phase.where(division_id: division).lazy.pluck(:id)
          type "Plot", id: Plot.where(division_id: division).lazy.pluck(:id)
        end
      end

      cannot %i[update destroy], Document, override: true
    end

    def division_calendar
      can :destroy, Event
    end
  end
end
