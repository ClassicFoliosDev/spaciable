# frozen_string_literal: true

namespace :phase_cpps do
  task migrate: :environment do

    CPP.destroy_all
    CPP.create(package: :free)
    CPP.create(package: :legacy)
    CPP.create(package: :essentials, value: 1.0)
    CPP.create(package: :elite, value: 2.5)

    [Phase, Invoice].each do |klass|
      klass.where(package: :essentials).update_all(cpp: 1.0)
      klass.where(package: :elite).update_all(cpp: 1.5)
    end
  end
end