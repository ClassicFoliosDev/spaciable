# frozen_string_literal: true

module PlotDocumentFixture
  module_function

  def category
    I18n.t("activerecord.attributes.document.categories.legal_and_warranty")
  end

  def category2
    I18n.t("activerecord.attributes.document.categories.locality")
  end

  def document100
    "Plot 100 homeowner manual.pdf"
  end

  def document10010
    "Plot 100.10 homeowner manual.pdf"
  end

  def document300
    "Plot 300 homeowner manual.pdf"
  end

  def document30010
    "Plot 300.10 homeowner manual.pdf"
  end

  def document200
    "Plot 200 homeowner manual.pdf"
  end

  def document20010
    "Plot 200.10 homeowner manual.pdf"
  end

  def rename_text
    "Homeowner manual"
  end
end
