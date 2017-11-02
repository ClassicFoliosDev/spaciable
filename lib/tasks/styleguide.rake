# frozen_string_literal: true

namespace :styleguide do
  desc "Compile the Component Styleguide"
  task compile: :environment do
    sh "livingstyleguide compile app/assets/styleguide.html.lsg public/styleguide.html"
  end
end
