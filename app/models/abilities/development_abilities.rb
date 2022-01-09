# frozen_string_literal: true

module Abilities
  module DevelopmentAbilities
    def development_abilities(developments, division_id, developer_id, user)
      crud_users(role: :development_admin, id: developments, model: "Development")
      crud_users(role: :site_admin, id: developments, model: "Development")

      development_notifications(developments, division_id, developer_id)
      development_faqs(developments, division_id, developer_id)
      development_contacts(developments, division_id, developer_id)
      development_documents(developments, division_id, developer_id)
      development_videos(developments)
      development_custom_tiles(developments)
      development_calendar
      crud_residents(developments)
      developments(developer_id, division_id, developments, user)
    end

    private

    def crud_residents(developments)
      can :crud, PlotResidency, plot: { development_id: developments }
      can :crud, Resident
      can :reinvite, Resident
    end

    def developments(developer_id, division_id, developments, user)
      can :read, Developer, id: developer_id
      can :read, Division, id: division_id
      can %i[read development_csv], Development, id: developments
      can %i[read update bulk_edit], Phase, development_id: developments
      can :read, Room, development_id: developments
      can %i[read update complete], Plot, development_id: developments

      can :read, UnitType, development_id: developments

      unit_type_ids = UnitType.where(development: developments).lazy.pluck(:id)

      can :read, Finish, rooms: { unit_type_id: unit_type_ids }
      can :read, Appliance, rooms: { unit_type_id: unit_type_ids }

      non_cas_developments(developments, user)
    end

    # Some users have access to multiple developments, and each development
    # may optionally have CAS enabled.  CAS security is set elsewhere for enabled
    # developments but non-enabled developnments have their security set here
    def non_cas_developments(developments, user)
      devs = developments.is_a?(Integer) ? [developments] : developments
      devs.each do |development|
        next if user.cas && Development.find(development).cas
        can :read, Finish, rooms: { plot: { development_id: development } }
        can :read, Appliance, rooms: { plot: { development_id: development } }
      end
    end

    def development_notifications(developments, division, developer)
      polymorphic_abilities Notification, :send_to do
        actions :read do
          type "Developer", id: developer
          type "Division", id: division
        end

        actions :manage do
          type "Development", id: developments
          type "Phase", id: Phase.where(development_id: developments).pluck(:id)
        end
      end

      cannot :manage, Notification, send_to_all: true
      cannot :send_to_all, Notification
    end

    def development_videos(developments)
      polymorphic_abilities Video, :videoable do
        type "Development", id: developments, actions: :manage
      end
    end

    def development_custom_tiles(developments)
      can :manage, CustomTile, development_id: developments
    end

    def development_faqs(developments, division, developer)
      polymorphic_abilities Faq, :faqable do
        type "Development", id: developments, actions: :manage
        type "Division", id: division, actions: :read if division
        type "Developer", id: developer, actions: :read
      end
    end

    def development_contacts(developments, division, developer)
      polymorphic_abilities Contact, :contactable do
        type "Development", id: developments, actions: :manage
        type "Division", id: division, actions: :read if division
        type "Developer", id: developer, actions: :read
        type "Phase", id: Phase.where(development_id: developments).lazy.pluck(:id),
                      actions: :manage
      end
    end

    def development_documents(developments, division, developer)
      polymorphic_abilities Document, :documentable do
        type "Division", id: division, actions: :read if division
        type "Developer", id: developer, actions: :read

        actions :manage do
          type "Development", id: developments
          type "UnitType", id: UnitType.where(development_id: developments).lazy.pluck(:id)
          type "Phase", id: Phase.where(development_id: developments).lazy.pluck(:id)
          type "Plot", id: Plot.where(development_id: developments).lazy.pluck(:id)
        end
      end
    end

    def development_calendar
      can :destroy, Event
    end
  end
end
