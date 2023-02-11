# frozen_string_literal: true

namespace :env_vars do
  task initialise: :environment do
    EnvVar.create(name: "services", value: "https://www.spaciable.io/services");
  end
end
