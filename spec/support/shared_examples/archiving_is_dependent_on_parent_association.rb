# frozen_string_literal: true

RSpec.shared_examples "archiving is dependent on parent association" do |parent_association|
  context "when #{parent_association} is destroyed" do
    it "shouild archive the #{described_class}" do
      subject.send(parent_association).destroy!

      expect(subject.reload.deleted_at).not_to be_nil
    end
  end
end
