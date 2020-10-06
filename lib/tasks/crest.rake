# frozen_string_literal: true

namespace :crest do
  desc "Reset the ts and cs status for all residents"
  task load: :environment do

    #delete then load test data for crest division migration
    developer = Developer.find_by(company_name: "Crest Nicholson")
    developer&.destroy

    # create
    developer = Developer.create(company_name: "Crest Nicholson",
                                 country: Country.find_by(name: "UK"))
    ["Regeneration", "Chiltern", "South",
     "Leave Division 1",
     "South West", "Midlands", "Eastern",
     "Leave Division 2"
    ].each do |division_name|
      division = Division.create(developer: developer, division_name: division_name)

      case division_name
      when "Regeneration"
        create(developer, division,
          ["Brightwells Yard",
           "West Village at Upper Longcross",
           "Leave Development 1",
           "Centenary Quay",
           "Wells Park Place",
           "Leave Development 1",
           "Brandon House",
           "Dylon Works",
           "The Picturehouse",
           "Arborfield Green",
           "Campbell Wharf",
           "Bath Riverside"
          ])
      when "Chiltern"
        create(developer, division,
          ["Monksmoor Park",
           "Alconbury Weald"
          ])
      when "South"
        create(developer, division,
          ["Nightingale Fields at Arborfield Green",
           "Mulberry View"
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
      developer = Developer.find_by!(company_name: "Crest Nicholson")
      throw "Cannot find developer Crest Nicholson" unless developer

      [
        {
          development_name: "Brightwells Yard",
          from_division: "Regeneration",
          to_division: "South"
        },
        {
          development_name: "West Village at Upper Longcross",
          from_division: "Regeneration",
          to_division: "South"
        },
        {
          development_name: "Centenary Quay",
          from_division: "Regeneration",
          to_division: "South"
        },
        {
          development_name: "Wells Park Place",
          from_division: "Regeneration",
          to_division: "South"
        },
        {
          development_name: "Brandon House",
          from_division: "Regeneration",
          to_division: "South"
        },
        {
          development_name: "Dylon Works",
          from_division: "Regeneration",
          to_division: "South"
        },
        {
          development_name: "The Picturehouse",
          from_division: "Regeneration",
          to_division: "South"
        },
        {
          development_name: "Arborfield Green",
          from_division: "Regeneration",
          to_division: "Chiltern"
        },
        {
          development_name: "Campbell Wharf",
          from_division: "Regeneration",
          to_division: "Chiltern"
        },
        {
          development_name: "Bath Riverside",
          from_division: "Regeneration",
          to_division: "South West"
        },
        {
          development_name: "Monksmoor Park",
          from_division: "Chiltern",
          to_division: "Midlands"
        },
        {
          development_name: "Nightingale Fields at Arborfield Green",
          from_division: "South",
          to_division: "Chiltern"
        },
        {
          development_name: "Mulberry View",
          from_division: "South",
          to_division: "Chiltern"
        },
        {
          development_name: "Alconbury Weald",
          from_division: "Chiltern",
          to_division: "Eastern"
        }
      ].each do |m|
        to = Division.find_by(division_name: m[:to_division], developer: developer)
        raise StandardError.new "Cannot find division #{m[:to_division]}" unless to
        from = Division.find_by(division_name: m[:from_division], developer: developer)
        raise StandardError.new "Cannot find division #{m[:from_division]}" unless from
        development = Development.find_by(name: m[:development_name],
                                           division: from)
        raise StandardError.new "Cannot find development #{m[:development_name]}" unless development

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
