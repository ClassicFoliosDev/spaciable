# frozen_string_literal: true
RSpec.shared_examples "archive when destroyed" do
  it "shouild be archived" do
    subject.destroy!

    expect(described_class.all).not_to include(subject)
    expect(described_class.with_deleted).to include(subject)
    expect(subject.reload.deleted_at).not_to be_nil
  end
end
