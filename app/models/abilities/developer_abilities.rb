# frozen_string_literal: true

module Abilities
  module DeveloperAbilities
    include PolymorphicAssociationAbilities

    def developer_abilities(developer)
      crud_users(role: :developer_admin, id: developer, model: "Developer")

      developer_notifications(developer)
      developer_faqs(developer)
      developer_contacts(developer)
      developer_documents(developer)
      developer_timelines(developer)
      developer_videos(developer)
      developer_calendar
      read_developers(developer)
      developer_build_progress(developer)
    end
    
    private
    
    def developer_build_progress(developer)
      polymorphic_abilities BuildSequence, :build_sequenceable do
        type "Developer", id: developer, actions: :manage
        type "Global", id: Global.root.id, actions: :read
      end
      can :read, Global
    end
    
    def developer_videos(developer)
      can :manage, Video, videoable_type: "Developer", videoable_id: developer
      Division.where(developer_id: developer).find_each do |division|
        can :manage, Video, videoable_type: "Division", videoable_id: division
      end
    end

    def developer_faqs(developer_id)
      polymorphic_abilities Faq, :faqable do
        type "Developer", id: developer_id, actions: :manage
      end
    end

    def developer_notifications(developer_id)
      polymorphic_abilities Notification, :send_to do
        type "Developer", id: developer_id, actions: :manage
      end

      cannot :manage, Notification, send_to_all: true
    end

    def developer_contacts(developer_id)
      polymorphic_abilities Contact, :contactable do
        type "Developer", id: developer_id, actions: :manage
        type "Phase", id: Phase.where(developer_id: developer_id).lazy.pluck(:id), actions: :manage
      end
    end

    def developer_documents(developer_id)
      polymorphic_abilities Document, :documentable do
        actions :manage do
          type "Developer", id: developer_id
          type "UnitType", id: UnitType.where(developer_id: developer_id).lazy.pluck(:id)
          type "Phase", id: Phase.where(developer_id: developer_id).lazy.pluck(:id)
          type "Plot", id: Plot.where(developer_id: developer_id).lazy.pluck(:id)
        end
      end
    end

    def read_developers(developer_id)
      can :read, Developer, id: developer_id
      can :read, Development, developer_id: developer_id
      can :read, Development, developer_id: developer_id
      can :read, Division, developer_id: developer_id
    end

    def developer_timelines(developer_id)
      polymorphic_abilities Timeline, :timelineable do
        type "Developer", id: developer_id, actions: :read
      end
      can %i[read show empty], Task
      can %i[show], Finale
    end

    def developer_calendar
      can :destroy, Event
    end
  end
end
