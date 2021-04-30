# frozen_string_literal: true

class Ability
  include CanCan::Ability
  include Abilities::UserPermissions
  include Abilities::CfAdminAbilities
  include Abilities::DeveloperAbilities
  include Abilities::DivisionAbilities
  include Abilities::DevelopmentAbilities
  include Abilities::SiteAbilities
  include Abilities::ResidentAbilities
  include Abilities::ClientSpecAbilities
  include Abilities::ConciergeAbilities

  def initialize(user, args = {})
    guest_abilities

    return unless user

    alias_action :create, :read, :update, :destroy, to: :crud

    if user.instance_of? Resident
      resident_abilities(user, args[:plot])
    else
      role_abilities(user.role, user, args)
      wysiwyg_permissions
    end
  end

  private

  def guest_abilities
    can :read, HowTo
  end

  def role_abilities(role, user, args)
    case role.to_sym
    when :cf_admin
      cf_admin_abilities
    when :developer_admin
      developer_admin_abilities(user, args)
    when :division_admin
      division_admin_abilities(user, args)
    when :development_admin
      development_admin_abilities(user, args)
    when :site_admin
      site_admin_abilities(user)
    when :concierge
      concierge_abilities(user)
    end
  end

  def wysiwyg_permissions
    can :access, :ckeditor
  end

  def developer_admin_abilities(user, args)
    developer_id = user.permission_level_id
    division_ids = Division.where(developer_id: developer_id).pluck(:id)
    development_ids = Development
                      .where(developer_id: developer_id)
                      .or(Development.where(division_id: division_ids))
                      .pluck(:id)

    developer_abilities(developer_id)
    division_abilities(division_ids, nil)
    development_abilities(development_ids, nil, nil, user) unless args[:non_development]
    client_spec_abilities(developer_id, development_ids, user)
  end

  def division_admin_abilities(user, args)
    division = user.permission_level

    division_abilities(division.id, division.developer_id)

    development_ids = Development.where(division_id: division).pluck(:id)
    development_abilities(development_ids, nil, nil, user) unless args[:non_development]
    client_spec_abilities(division.developer_id, development_ids, user)
  end

  def development_admin_abilities(user, args)
    development = user.permission_level
    division = development.division
    developer_id = development.developer_id || division&.developer_id

    unless args[:non_development]
      development_abilities(development.id,
                            development.division_id,
                            developer_id,
                            user)
    end

    client_spec_abilities(developer_id, [development], user)
  end

  def site_admin_abilities(user)
    development = user.permission_level
    division = development.division
    developer_id = development.developer_id || division&.developer_id

    site_abilities(development.id, development.division_id, developer_id)
    client_spec_abilities(developer_id, [development], user)
  end
end
