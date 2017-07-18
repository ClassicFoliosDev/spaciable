# frozen_string_literal: true
module Abilities
  module DevelopmentAbilities
    def development_abilities(development, division_id, developer_id)
      crud_users(role: :development_admin, id: development, model: "Development")

      development_notifications(development, division_id, developer_id)
      development_faqs(development, division_id, developer_id)
      development_contacts(development, division_id, developer_id)
      development_documents(development, division_id, developer_id)
      development_videos(development)
      crud_residents(development)
      read_developments(developer_id, division_id, development)
    end

    private

    def crud_residents(development)
      can :crud, PlotResidency, plot: { development_id: development }
      cannot :create, PlotResidency do |residency|
        residency.plot.reload.resident.present?
      end
      can :crud, Resident, plot: { development_id: development }
    end

    def read_developments(developer_id, division_id, development)
      can :read, Developer, id: developer_id
      can :read, Division, id: division_id
      can :read, Development, id: development
      can :read, Phase, development_id: development
      can :read, Room, development_id: development
      can :read, Plot, development_id: development

      can :read, UnitType, development_id: development

      unit_type_ids = UnitType.where(development: development).lazy.pluck(:id)
      can :read, Finish, rooms: { unit_type_id: unit_type_ids }
      can :read, Finish, rooms: { plot: { development_id: development } }
      can :read, Appliance, rooms: { unit_type_id: unit_type_ids }
      can :read, Appliance, rooms: { plot: { development_id: development } }
    end

    def development_notifications(development, division, developer)
      polymorphic_abilities Notification, :send_to do
        actions :read do
          type "Developer", id: developer
          type "Division", id: division
        end

        actions :manage do
          type "Development", id: development
          type "Phase", id: Phase.where(development_id: development).pluck(:id)
        end
      end

      cannot :manage, Notification, send_to_all: true
      cannot :send_to_all, Notification
    end

    def development_videos(development)
      can :manage, Video, videoable_id: development
    end

    def development_faqs(development, division, developer)
      polymorphic_abilities Faq, :faqable do
        type "Development", id: development, actions: :manage
        type "Division", id: division, actions: :read if division
        type "Developer", id: developer, actions: :read
      end
    end

    def development_contacts(development, division, developer)
      polymorphic_abilities Contact, :contactable do
        type "Development", id: development, actions: :manage
        type "Division", id: division, actions: :read if division
        type "Developer", id: developer, actions: :read
      end
    end

    def development_documents(development, division, developer)
      polymorphic_abilities Document, :documentable do
        type "Division", id: division, actions: :read if division
        type "Developer", id: developer, actions: :read

        actions :manage do
          type "Development", id: development
          type "UnitType", id: UnitType.where(development_id: development).lazy.pluck(:id)
          type "Phase", id: Phase.where(development_id: development).lazy.pluck(:id)
          type "Plot", id: Plot.where(development_id: development).lazy.pluck(:id)
        end
      end
    end
  end
end
