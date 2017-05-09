# frozen_string_literal: true
module PlotResidencyFixture
  extend ModuleImporter
  import_module CreateFixture

  module_function

  def original_email
    "jo@bloggs.com"
  end

  def updated_email
    "joe@blogs.com"
  end

  ATTRS = {
    created: {
      title: "Mrs",
      first_name: "Jo",
      last_name: "Bloggs",
      email: original_email,
      completion_date: I18n.l(Time.zone.today.advance(days: 7))
    },
    updated: {
      title: "Mr",
      first_name: "Joe",
      last_name: "Blogs",
      email: original_email,
      completion_date: I18n.l(Time.zone.today.advance(days: 20))
    }
  }.freeze

  def setup
    create_developer
    create_development
    create_unit_type
    create_development_plot

    Sidekiq::Testing.fake!
  end

  def attrs(scope = :created)
    ATTRS[scope.to_sym]
  end

  def plot
    development.plots.first
  end
end
