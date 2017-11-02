# frozen_string_literal: true

module DocumentFixture
  module_function

  def document_name
    "Shower pdf title"
  end

  def updated_document_name
    "Dishwasher pdf title"
  end

  def updated_document_id
    Document.find_by(title: updated_document_name).id
  end

  def second_document_name
    "Microwave pdf title"
  end
end
