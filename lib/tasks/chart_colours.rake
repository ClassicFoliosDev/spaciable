# frozen_string_literal: true

namespace :chart_colours do
  task initialise: :environment do

    ChartColour.create(key: :empty, colour: "#f2f2f2");
    ChartColour.create(key: :plots_with_activated_residents, colour: "#FF2C55");
    ChartColour.create(key: :plots_with_invited_residents, colour: "#FF2C55");
    ChartColour.create(key: :plots_not_invited, colour: "#002A3A");
    ChartColour.create(key: :invited_plots_pending_activation, colour: "#9D9D9C");
    ChartColour.create(key: :highest_activation, colour: "#FF2C55");
    ChartColour.create(key: :lowest_activation, colour: "#002A3A");
    ChartColour.create(key: :placing_row, colour: "#002A3A");
    ChartColour.create(key: :hundred_percent, colour: "#B1BBB3");

  end

end
