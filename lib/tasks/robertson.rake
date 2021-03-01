# frozen_string_literal: true

namespace :robertson do
  task initialise: :environment do
    init_robertson
  end

  def init_robertson
    developer = Developer.find_by(company_name: "Robertson Homes")
    return unless developer

    set_lau(developer)
    developer.divisions.each do |division|
      set_lau(division)
      division.developments.each { |d| set_lau_development(d) }
    end

    developer.developments.each { |d| set_lau_development(d) }
  end

  def set_lau_development(development)
    set_lau(development)
    development.phases.each do |phase|
      set_lau(phase)
      phase.plots.each { |p| set_lau(p) }
    end
  end

  def set_lau(klass)
    klass.documents.each { |d| d.update_attributes(lau_visible: true) }
  end
end
