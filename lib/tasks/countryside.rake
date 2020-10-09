# frozen_string_literal: true

namespace :countryside do
  task load: :environment do

    #delete then load test data for Countryside Properties division migration

    #delete first
    developer = Developer.find_by(company_name: "Countryside Properties")
    developer&.destroy

    # create
    developer = Developer.create(company_name: "Countryside Properties",
                                 country: Country.find_by(name: "UK"))
    ["Partnerships Manchester and Cheshire East",
     "Partnerships Merseyside and Cheshire West",
     "Leave Division"
    ].each do |division_name|
      division = Division.create(developer: developer, division_name: division_name)

      case division_name
      when "Partnerships Manchester and Cheshire East"
        create(developer, division,
          ["Dutton Fields",
           "Leave Development"
          ])
      else
        create(developer, division,
          ["Exisiting development 1",
           "Exisiting development 2"
          ])
      end
    end
  end

  task migrate: :environment do
    ActiveRecord::Base.transaction do
      developer = Developer.find_by!(company_name: "Countryside Properties")
      throw "Cannot find developer Countryside Properties" unless developer

      [
        {
          development_name: "Dutton Fields",
          from_division: "Partnerships Manchester and Cheshire East",
          to_division: "Partnerships Merseyside and Cheshire West"
        }
      ].each do |m|
        to = Division.find_by(division_name: m[:to_division], developer: developer)
        from = Division.find_by(division_name: m[:from_division], developer: developer)
        next unless to && from

        development = Development.find_by(name: m[:development_name],
                                           division: from)
        next unless development

        Room.where(division: from, development: development).update_all(division_id: to.id)
        UnitType.where(division: from, development: development).update_all(division_id: to.id)
        Plot.where(division: from, development: development).update_all(division_id: to.id)
        Phase.where(division: from, development: development).update_all(division_id: to.id)
        Development.where(id: development, division: from).update_all(division_id: to.id)
      end
    end
  end

  def create(developer, division, developments)
    developments.each do |development|
      development = Development.create(name: development, division: division)
      phase = Phase.create(name: "#{development} phase 1", development: development, division: division)
      unit_type = UnitType.create(name: "#{development} UT", development: development, division: division)
      (1..2).each { |r| Room.create(name: r, developer: developer, development: development, division: division) }
      (1..3).each { |p| Plot.create(number: p, phase: phase, unit_type: unit_type, developer: developer, development: development, division: division) }
    end
  end
end
