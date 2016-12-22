# frozen_string_literal: true
class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    alias_action :create, :read, :update, :destroy, to: :crud
    role_abilities(user.role, user)
  end

  private

  def role_abilities(role, user)
    case role.to_sym
    when :cf_admin
      can :manage, :all

    when :client_admin
      client_admin_abilities

    when :client_user
      client_user_abilities(user)

    when :owner
      owner_abilities(user)
    end
  end

  def client_user_abilities(user)
    if user.division.present?
      division = user.division

      client_user_division_abilities(division.id, division.developer_id)
    elsif user.developer.present?
      developer_id = user.developer.id
      division_ids = Division.where(developer_id: developer_id).pluck(:id)

      client_user_developer_abilities(developer_id)
      client_user_division_abilities(division_ids, developer_id)
    end
  end

  # rubocop:disable MethodLength
  # Method is long, but not complex for a user to read
  def client_admin_abilities
    can :manage,
        [
          Document,
          Finish,
          Image,
          Plot,
          User
        ]

    can :read,
        [
          Developer,
          Development,
          Division,
          Phase,
          Room,
          UnitType
        ]
  end
  # rubocop:enable MethodLength

  def client_user_developer_abilities(developer)
    can :crud, Document, developer_id: developer
    can :crud, Finish, developer_id: developer
    can :crud, Image, developer_id: developer
    can :crud, Plot, developer_id: developer
    can :crud, User, developer_id: developer

    can :read, Developer, id: developer
    can :read, Development, developer_id: developer
    can :read, Development, developer_id: developer
    can :read, Division, developer_id: developer
    can :read, Phase, developer_id: developer
    can :read, Room, developer_id: developer
    can :read, UnitType, developer_id: developer
  end

  def client_user_division_abilities(division, developer_id)
    can :crud, Document, division_id: division
    can :crud, Finish, division_id: division
    can :crud, Image, division_id: division
    can :crud, Plot, division_id: division
    can :crud, User, division_id: division

    can :read, Developer, id: developer_id
    can :read, Development, division_id: division
    can :read, Division, id: division
    can :read, Phase, division_id: division
    can :read, Room, division_id: division
    can :read, UnitType, division_id: division
  end

  def owner_abilities(user)
    development_ids = user.plots.pluck(:development_id)

    can :read, Developer, developments: { id: development_ids }
    can :read, Development, id: development_ids
    can :read, Division, developer: { developments: { id: development_ids } }
    can :read, Document, development_id: development_ids
    can :read, Finish, development_id: development_ids
    can :read, Image, development_id: development_ids
    can :read, Phase, development_id: development_ids
    can :read, Plot, development_id: development_ids
    can :read, Room, development_id: development_ids
    can :read, UnitType, development_id: development_ids

    can :manage, User, id: user.id
  end
end
