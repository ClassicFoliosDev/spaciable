# frozen_string_literal: true
require "rails_helper"

RSpec.describe DocumentLibraryService do
  context "appliances and documents" do
    it "concatenates appliance manuals with other documents" do
      appliance = create(:appliance, manual: "Manual1.pdf", name: "Appliance 1")
      developer = create(:developer)
      document = create(:document, title: "Developer document", file: "Document1.pdf", developer: developer)
      appliances = []
      appliances.push(appliance)
      documents = []
      documents.push(document)
      result = described_class.call(documents, appliances)

      expect(result.count).to eq(2)
      expect(result[0][:name]).to eq(document.title)
      expect(result[1][:name]).to eq(appliance.name)
    end

    it "sorts and returns only the most recent" do
      developer = create(:developer)
      appliance1 = create(:appliance, manual: "Manual1.pdf", name: "Appliance 1")
      document1 = create(:document, title: "Developer document 2", file: "Document2.pdf", developer: developer)
      appliance2 = create(:appliance, manual: "Manual3.pdf", name: "Appliance 3")
      appliance3 = create(:appliance, manual: "Manual4.pdf", name: "Appliance 4")
      document2 = create(:document, title: "Developer document 5", file: "Document5.pdf", developer: developer)
      appliance4 = create(:appliance, manual: "Manual6.pdf", name: "Appliance 6")
      document3 = create(:document, title: "Developer document 7", file: "Document7.pdf", developer: developer)
      document4 = create(:document, title: "Developer document 8", file: "Document8.pdf", developer: developer)
      document5 = create(:document, title: "Developer document 9", file: "Document9.pdf", developer: developer)
      appliance5 = create(:appliance, manual: "Manual10.pdf", name: "Appliance 10")
      appliances = []
      appliances.push(appliance1, appliance2, appliance3, appliance4, appliance5)
      documents = []
      documents.push(document1, document2, document3, document4, document5)
      result = described_class.call(documents, appliances)

      expect(result.count).to eq(6)
      expect(result[0][:name]).to eq(appliance5.name)
      expect(result[1][:name]).to eq(document5.title)
      expect(result[2][:name]).to eq(document4.title)
      expect(result[3][:name]).to eq(document3.title)
      expect(result[4][:name]).to eq(appliance4.name)
      expect(result[5][:name]).to eq(document2.title)
    end
  end
end
