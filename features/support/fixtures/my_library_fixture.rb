# frozen_string_literal: true

require_relative "file_create_fixture"

module MyLibraryFixture
  extend ModuleImporter
  import_module FileCreateFixture

  module_function

  DOCUMENTS = [
    {
      title: "Developer Document",
      file: "developer_document.pdf",
      documentable: -> { CreateFixture.developer },
      category: :my_home,
      pinned: false
    },
    {
      title: "Development Document",
      file: "development_document.pdf",
      documentable: -> { CreateFixture.development },
      category: :my_home,
      pinned: true
    },
    {
      title: "Unit Type Document",
      file: "unit_type_document.pdf",
      documentable: -> { CreateFixture.unit_type },
      category: :legal_and_warranty,
      pinned: false
    },
    {
      title: "Phase Plot Document",
      file: "phase_plot_document.pdf",
      documentable: -> { CreateFixture.phase_plot },
      category: :my_home,
      pinned: false
    }
  ].freeze

  def create_room_appliance_and_finish
    CreateFixture.create_appliance_manufacturer
    CreateFixture.create_resident_under_a_phase_plot_with_appliances_and_rooms
    CreateFixture.create_finish_room

    ApplianceFixture.update_appliance_manual
    ApplianceFixture.update_appliance_guide
  end

  def create_documents
    DOCUMENTS.each do |attrs|
      path = Rails.root.join("features", "support", "files", attrs[:file])
      file = Rack::Test::UploadedFile.new(path)

      document = FactoryGirl.create(
        :document,
        title: attrs[:title],
        file: file,
        documentable: attrs[:documentable].call,
        category: attrs[:category],
        pinned: attrs[:pinned]
      )

      preview_file_name = "preview_#{attrs[:file]}"
      preview_file_name = preview_file_name.sub("pdf", "jpg")
      write_file(document.id, preview_file_name)
    end
  end

  def default_category_name
    I18n.t("activerecord.attributes.document.categories.my_home")
  end

  def other_category_name
    I18n.t("activerecord.attributes.document.categories.legal_and_warranty")
  end

  def appliances_category_name
    Appliance.model_name.human.pluralize
  end

  def recent_documents
    all_documents.reverse.take(5)
  end

  def default_filtered_documents
    DOCUMENTS.select { |attrs| attrs[:category] == :my_home }.map(&method(:front_end_attrs))
  end

  def default_filtered_out_documents
    all_documents - default_filtered_documents
  end

  def filtered_documents
    DOCUMENTS.select { |attrs| attrs[:category] == :legal_and_warranty }.map(&method(:front_end_attrs))
  end

  def filtered_out_documents
    all_documents - filtered_documents
  end

  def appliance_manuals
    [CreateFixture.full_appliance_name]
  end

  def not_appliance_manuals
    all_documents << CreateFixture.appliance_without_manual_name
  end

  private

  module_function

  def all_documents
    DOCUMENTS.map(&method(:front_end_attrs))
  end

  def front_end_attrs(attrs)
    document = Document.find_by(title: attrs[:title])

    [attrs[:title], document.file.url]
  end
end
