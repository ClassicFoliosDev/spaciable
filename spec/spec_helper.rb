# frozen_string_literal: true

require "pry"
require "webmock/rspec"
require "ext/string"

$LOAD_PATH.unshift("app/errors")
$LOAD_PATH.unshift("app/services")
$LOAD_PATH.unshift("spec/support")

RSpec.configure do |config|
  WebMock.disable_net_connect!(allow_localhost: true)

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.syntax = :expect
  end

  config.before(:each) do
    Global.create(name: "CFAdmin") if Global.first.nil?

    # create the master build sequence
    sequence = BuildSequence.create(build_sequenceable: Global.first)

    # migrate all 'no progress status' plots (value 15) to 'soon' (0)
    Plot.where(progress: 15).update_all(progress: 0)

    Plot.progresses.each do |t, v|
      BuildStep.create(title: I18n.t("activerecord.attributes.plot.progresses.#{t}"),
                       description: "Your Build Progress has been updated to:\r\n\r\n" +
                                    I18n.t("activerecord.attributes.plot.progresses.#{t}"),
                       order: v + 1,
                       build_sequence: sequence)
    end
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.example_status_persistence_file_path = "spec/examples.txt"

  config.disable_monkey_patching!

  if config.files_to_run.one?
    config.default_formatter = "doc"
  end

  config.order = :random

  Kernel.srand config.seed

  ENV['TZ'] = 'Europe/London'
  ENV['RSPEC'] = 'true'
end
