# frozen_string_literal: true

require_relative "create_fixture"

module AnalyticsFixture
  extend ModuleImporter
  import_module CreateFixture

  module_function

  def create_first_developer
    create_developer
    create_division
    create_development
    create_division_development
    create_phases
    create_unit_type
    create_phase_plot
    create_division_development_plot
    plot = Plot.find_by(number: CreateFixture.phase_plot_name)
    plot.update_attributes(completion_release_date: Time.zone.now)
    plot = Plot.find_by(number: CreateFixture.division_plot_name)
    plot.update_attributes(reservation_release_date: Time.zone.now,
                           completion_release_date: Time.zone.now)
  end

  def create_second_developer
    FactoryGirl.create(:developer, company_name: second_developer_name, house_search: false,
                       enable_services: true, development_faqs: true)
    FactoryGirl.create(:division, division_name: second_division_name, developer: second_developer)
    FactoryGirl.create(:division_development, division: second_division,
                       name: second_division_development_name, enable_snagging: true)
    FactoryGirl.create(:unit_type, name: second_unit_type_name, development: second_division_development)
    FactoryGirl.create(:phase, name: second_phase_name, development: second_division_development)
    FactoryGirl.create(:phase_plot, phase: second_phase, number: second_plot_name,
                       unit_type: second_unit_type, reservation_release_date: Time.zone.now - 2.days)
  end

  def second_developer_name
    "Second Developer"
  end

  def second_division_name
    "Second Division"
  end  

  def second_division_development_name
    "Second Development"
  end

  def second_unit_type_name
    "Second Unit"
  end

  def second_phase_name
    "Second Phase"
  end

  def second_plot_name
    "22"
  end


  def second_developer
    Developer.find_by(company_name: second_developer_name)
  end

  def second_division
    Division.find_by(division_name: second_division_name)
  end

  def second_division_development
    Development.find_by(name: second_division_development_name)
  end

  def second_unit_type
    UnitType.find_by(name: second_unit_type_name)
  end

  def second_phase
    Phase.find_by(name: second_phase_name)
  end

  def second_plot
    Plot.find_by(number: second_plot_name)
  end
end
 