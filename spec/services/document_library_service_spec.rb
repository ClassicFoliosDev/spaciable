# frozen_string_literal: true

require "rails_helper"

RSpec.describe DocumentLibraryService do
  context "sorts documents" do
    it "sorts and returns only the 6 most recent" do
      developer = create(:developer)
      document1 = create(:document, title: "Developer document 2", file: "Document2.pdf", documentable: developer)
      document2 = create(:document, title: "Developer document 5", file: "Document5.pdf", documentable: developer)
      document3 = create(:document, title: "Developer document 7", file: "Document7.pdf", documentable: developer)
      document4 = create(:document, title: "Developer document 8", file: "Document8.pdf", documentable: developer)
      document5 = create(:document, title: "Developer document 9", file: "Document9.pdf", documentable: developer)
      document6 = create(:document, title: "Developer document 20", file: "Document9.pdf", documentable: developer)
      document7 = create(:document, title: "Developer document 4", file: "Document9.pdf", documentable: developer)
      documents = []
      documents.push(document1, document2, document3, document4, document5, document6, document7)
      result = described_class.call(documents, [])

      expect(result.count).to eq(6)
      expect(result[0][:name]).to eq(document7.title)
      expect(result[1][:name]).to eq(document6.title)
      expect(result[2][:name]).to eq(document5.title)
      expect(result[3][:name]).to eq(document4.title)
      expect(result[4][:name]).to eq(document3.title)
      expect(result[5][:name]).to eq(document2.title)
    end
  end
end
