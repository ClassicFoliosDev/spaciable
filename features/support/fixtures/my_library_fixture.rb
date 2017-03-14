# frozen_string_literal: true
module MyLibraryFixture
  module_function

  DOCUMENTS = [
    {
      title: "Developer Document",
      file: "developer_document.pdf",
      documentable: -> { CreateFixture.developer },
      category: :my_home
    },
    {
      title: "Development Document",
      file: "development_document.pdf",
      documentable: -> { CreateFixture.development },
      category: :my_home
    },
    {
      title: "Unit Type Document",
      file: "unit_type_document.pdf",
      documentable: -> { CreateFixture.unit_type },
      category: :my_home
    },
    {
      title: "Phase Plot Document",
      file: "phase_plot_document.pdf",
      documentable: -> { CreateFixture.phase_plot },
      category: :my_home
    },
    {
      title: "Developer Legal Document",
      file: "developer_legal_document.pdf",
      documentable: -> { CreateFixture.developer },
      category: :legal_and_warranty
    }
  ].freeze

  delegate :resident, :appliance, to: :CreateFixture
  module_function :resident, :appliance

  def setup
    CreateFixture.create_resident_under_a_phase_plot_with_appliances_and_rooms

    create_appliance_manual
    create_documents
  end

  def create_documents
    DOCUMENTS.each do |attrs|
      path = Rails.root.join("features", "support", "files", attrs[:file])
      file = Rack::Test::UploadedFile.new(path)

      FactoryGirl.create(
        :document,
        title: attrs[:title],
        file: file,
        documentable: attrs[:documentable].call,
        category: attrs[:category]
      )
    end
  end

  def create_appliance_manual
    filename = "washing_machine_manual.pdf"
    path = Rails.root.join("features", "support", "files", filename)

    File.open(path) do |file|
      CreateFixture.appliance.update_attribute(:manual, file)
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
    my_appliance = appliance

    [[my_appliance.name, my_appliance.manual.url]]
  end

  def not_appliance_manuals
    all_documents << [CreateFixture.appliance_without_manual_name, nil]
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
