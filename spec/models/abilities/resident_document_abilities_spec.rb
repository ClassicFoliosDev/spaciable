# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe "Resident Document Abilities" do

  let(:developer) { create(:developer) }
  let(:division) { create(:division, developer: developer) }
  let(:development) { create(:development, division: division, developer: developer) }
  let(:phase) { create(:phase, development: development) }
  let(:phase_plot) { create(:phase_plot, phase: phase) }
  let(:plot_residency) { create(:plot_residency, plot_id: phase_plot.id, resident_id: resident.id, role: 'tenant') }
  let(:development_admin) { create(:development_admin) }
  let(:cf_admin) { create(:cf_admin) }

  context "a homeowner resident" do
    subject { Ability.new(current_resident, plot: phase_plot) }
    let(:current_resident) { create(:resident, :with_residency, plot: phase_plot) }

    it "cannot read documents for someone else's plot" do
      document = build(:document, documentable: create(:plot, development: phase_plot.development))
      expect(subject).not_to be_able_to(:read, document)
    end

    it "cannot read documents for someone else's phase plot" do
      document = build(:document, documentable: create(:plot, phase: phase_plot.phase))
      expect(subject).not_to be_able_to(:read, document)
    end

    it "cannot read documents for another development" do
      development = create(:development, developer: phase_plot.developer)
      document = build(:document, documentable: development)
      expect(subject).not_to be_able_to(:read, document)
    end

    it "can READ developer documents" do
      document = build(:document, documentable: developer)

      expect(subject).to be_able_to(:read, document)
    end

    it "can READ division documents" do
      document = build(:document, documentable: division)

      expect(subject).to be_able_to(:read, document)
    end

    it "can READ development documents" do
      document = build(:document, documentable: development)

      expect(subject).to be_able_to(:read, document)
    end

    it "can READ unit type documents" do
      unit_type = phase_plot.unit_type
      document = build(:document, documentable: phase_plot.unit_type)

      expect(subject).to be_able_to(:read, document)
    end

    it "can READ phase documents" do
      phase = phase_plot.phase
      document = build(:document, documentable: phase)

      expect(subject).to be_able_to(:read, document)
    end

    it "can READ plot documents" do
      document = build(:document, documentable: phase_plot)

      expect(subject).to be_able_to(:read, document)
    end
  end

  context "a tenant resident" do
    subject { Ability.new(current_tenant, plot: phase_plot) }
    let(:current_tenant) { create(:resident, :with_tenancy, plot: phase_plot) }
    let(:another_plot) { create(:plot, phase: phase) }

    it "cannot read documents for someone else's plot" do
      document = build(:document, documentable: create(:plot, development: development))
      expect(subject).not_to be_able_to(:read, document)
    end

    it "cannot read documents for someone else's phase plot" do
      document = build(:document, documentable: create(:plot, phase: phase))
      expect(subject).not_to be_able_to(:read, document)
    end

    it "cannot read documents for another development" do
      development = create(:development, developer: developer)
      document = build(:document, documentable: development)
      expect(subject).not_to be_able_to(:read, document)
    end

    it "cannot read developer documents" do
      document = build(:document, documentable: developer)

      expect(subject).not_to be_able_to(:read, document)
    end

    it "cannot read division documents" do
      document = build(:document, documentable: division)

      expect(subject).not_to be_able_to(:read, document)
    end

    # By default, a tenant has no ability to read development, phase, unit type, and plot documents

    it "can not read development documents" do
      document = build(:document, documentable: development)

      expect(subject).not_to be_able_to(:read, document)
    end

    it "can not read unit type documents" do
      unit_type = phase_plot.unit_type
      document = build(:document, documentable: unit_type)

      expect(subject).not_to be_able_to(:read, document)
    end

    it "can not read phase documents" do
      phase = phase_plot.phase
      document = build(:document, documentable: phase)

      expect(subject).not_to be_able_to(:read, document)
    end

    it "can not read plot documents" do
      document = build(:document, documentable: phase_plot)

      expect(subject).not_to be_able_to(:read, document)
    end

    it "can READ developer documents if a homeowner has enabled tenant read" do
      # Document is not valid because it's missing a file, but that shouldn't affect this test, which is about permissions
      document = build(:document, documentable: phase_plot.developer)
      document.save(validate: false)
      plot_document = create(:plot_document, document_id: document.id, plot_id: phase_plot.id, enable_tenant_read: true)

      expect(subject).to be_able_to(:read, document)
    end

    it "can READ division documents if a homeowner has enabled tenant read" do
      document = build(:document, documentable: phase_plot.division)
      document.save(validate: false)
      plot_document = create(:plot_document, document_id: document.id, plot_id: phase_plot.id, enable_tenant_read: true)

      expect(subject).to be_able_to(:read, document)
    end

    it "can READ development documents if a homeowner has enabled tenant read" do
      document = build(:document, documentable: phase_plot.development)
      document.save(validate: false)
      plot_document = create(:plot_document, document_id: document.id, plot_id: phase_plot.id, enable_tenant_read: true)

      expect(subject).to be_able_to(:read, document)
    end

    it "can READ phase documents if a homeowner has enabled tenant read" do
      document = build(:document, documentable: phase)
      document.save(validate: false)
      plot_document = create(:plot_document, document_id: document.id, plot_id: phase_plot.id, enable_tenant_read: true)

      expect(subject).to be_able_to(:read, document)
    end

   it "can READ unit type documents if a homeowner has enabled tenant read" do
      document = build(:document, documentable: phase_plot.unit_type)
      document.save(validate: false)
      plot_document = create(:plot_document, document_id: document.id, plot_id: phase_plot.id, enable_tenant_read: true)

      expect(subject).to be_able_to(:read, document)
    end

   it "can READ plot documents if a homeowner has enabled tenant read" do
      document = build(:document, documentable: phase_plot)
      document.save(validate: false)
      plot_document = create(:plot_document, document_id: document.id, plot_id: phase_plot.id, enable_tenant_read: true)

      expect(subject).to be_able_to(:read, document)
    end

    it "cannot read developer documents if a homeowner has enabled tenant read for another plot" do
      document = build(:document, documentable: developer)
      document.save(validate: false)
      plot_document = create(:plot_document, document_id: document.id, plot_id: another_plot.id, enable_tenant_read: true)

      expect(subject).not_to be_able_to(:read, document)
    end

    it "cannot read division documents if a homeowner has enabled tenant read for another plot" do
      document = build(:document, documentable: division)
      document.save(validate: false)
      plot_document = create(:plot_document, document_id: document.id, plot_id: another_plot.id, enable_tenant_read: true)

      expect(subject).not_to be_able_to(:read, document)
    end

    it "cannot read development documents if a homeowner has enabled tenant read for another plot" do
      document = build(:document, documentable: phase_plot.development)
      document.save(validate: false)
      plot_document = create(:plot_document, document_id: document.id, plot_id: another_plot.id, enable_tenant_read: true)

      expect(subject).not_to be_able_to(:read, document)
    end

    it "cannot read phase documents if a homeowner has enabled tenant read for another plot" do
      document = build(:document, documentable: phase)
      document.save(validate: false)
      plot_document = create(:plot_document, document_id: document.id, plot_id: another_plot.id, enable_tenant_read: true)

      expect(subject).not_to be_able_to(:read, document)
    end

   it "cannot read unit type documents if a homeowner has enabled tenant read for another plot" do
      document = build(:document, documentable: phase_plot.unit_type)
      document.save(validate: false)
      plot_document = create(:plot_document, document_id: document.id, plot_id: another_plot.id, enable_tenant_read: true)

      expect(subject).not_to be_able_to(:read, document)
    end

   it "cannot read plot documents if a homeowner has enabled tenant read for another plot" do
      document = build(:document, documentable: phase_plot)
      document.save(validate: false)
      plot_document = create(:plot_document, document_id: document.id, plot_id: another_plot.id, enable_tenant_read: true)

      expect(subject).not_to be_able_to(:read, document)
    end
  end
end
