# frozen_string_literal: true

module AdditionalRoleFixture
  module_function

  ADDITIONAL = "additional"

  EMAIL = "#{ADDITIONAL}@gmail.com"

  def additional?(option)
    option&.strip() == ADDITIONAL
  end

  def resource(additional, resource_name)
    if additional?(additional)
      send("additional_#{resource_name}")
    else
      CreateFixture.send(resource_name)
    end
  end

  def resident_email(additional)
    if additional?(additional)
      AdditionalRoleFixture::EMAIL
    else
      CreateFixture.resident.email
    end
  end

  def developer(additional)
    additional?(additional) ? additional_developer : CreateFixture.developer
  end

  def division(additional)
    additional?(additional) ? additional_division : CreateFixture.division
  end

  def development(additional)
    additional?(additional) ? additional_development : CreateFixture.development
  end

  def division_development(additional)
    additional?(additional) ? additional_division_development : CreateFixture.division_development
  end

  def phase(additional)
    additional?(additional) ? additional_division_phase : CreateFixture.phase
  end

  def division_phase(additional)
    additional?(additional) ? additional_division_phase : CreateFixture.division_phase
  end

  def get(additional, resource, parent = nil)
    if additional?(additional)
      send "additional_#{CreateFixture.ResourceName(resource, parent)}"
    else
      CreateFixture.get(resource, parent)
    end
  end

  def additional_developer
    Developer.find_by(company_name: ADDITIONAL)
  end

  def additional_division
    Division.find_by(division_name: ADDITIONAL)
  end

  def additional_development
    Development.find_by(name: ADDITIONAL, division: nil)
  end

  def additional_division_development
    Development.find_by(name: ADDITIONAL, division: additional_division)
  end

  def additional_division_phase
    Phase.find_by(name: ADDITIONAL, division: additional_division)
  end

end
