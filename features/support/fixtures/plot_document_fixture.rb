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
    "100 homeowner manual.pdf"
  end

  def document10010
    "100.10 homeowner manual.pdf"
  end

  def document300
    "300 homeowner manual.pdf"
  end

  def document30010
    "300.10 homeowner manual.pdf"
  end

  def document200
    "200 homeowner manual.pdf"
  end

  def document20010
    "200.10 homeowner manual.pdf"
  end
end
