# frozen_string_literal: true

require "rails_helper"
require "cancan/matchers"

RSpec.describe "Resident Abilities" do
  context "with a plot residency" do
    subject { Ability.new(current_resident, plot) }
    let(:current_resident) { create(:resident, :with_residency) }
    let(:plot) { current_resident.plots.first }

    it "can manage itself" do
      expect(subject).to be_able_to(:manage, current_resident)
    end

    it_behaves_like "it can read polymorphic models associated with the residency", Document, :documentable

    it "cannot read documents for someone else's plot" do
      document = build(:document, documentable: create(:plot, development: plot.development))
      expect(subject).not_to be_able_to(:read, document)
    end

    it "cannot read documents for someone else's phase plot" do
      document = build(:document, documentable: create(:plot, phase: plot.phase))
      expect(subject).not_to be_able_to(:read, document)
    end

    it "cannot read documents for another development" do
      development = create(:development, developer: plot.developer)
      document = build(:document, documentable: development)
      expect(subject).not_to be_able_to(:read, document)
    end

    it "has READ access to a plots developer" do
      developer = plot.developer

      expect(subject).to be_able_to(:read, developer)
    end

    it "has READ access to a plots development" do
      development = plot.development

      expect(subject).to be_able_to(:read, development)
    end

    it "has READ access to its plot" do
      expect(subject).to be_able_to(:read, plot)
    end

    it "does not have access to other plots" do
      plot2 = create(:plot, development: plot.development)
      expect(subject).not_to be_able_to(:read, plot2)
    end

    it "has READ access to plots unit type" do
      unit_type = plot.unit_type
      raise "unit type is nil" unless unit_type

      expect(subject).to be_able_to(:read, unit_type)
    end

    it "has READ access to plots unit type documents" do
      unit_type = plot.unit_type
      document = build(:document, documentable: unit_type)

      expect(subject).to be_able_to(:read, document)
    end

    it "has READ access to the plots unit types rooms" do
      unit_type = plot.unit_type
      room = create(:room, unit_type: unit_type)

      expect(subject).to be_able_to(:read, room)
    end

    it "cannot read unit type rooms used as plot room templates" do
      unit_type = plot.unit_type
      template_room = create(:room, unit_type: unit_type)

      create(:room, plot: plot, template_room_id: template_room.id)

      expect(subject).not_to be_able_to(:read, template_room)
    end

    it "can read plot rooms" do
      unit_type = plot.unit_type
      template_room = create(:room, unit_type: unit_type)

      plot_room = create(:room, plot: plot, template_room_id: template_room.id)

      expect(subject).to be_able_to(:read, plot_room)
    end

    it "has READ access to the plots rooms finishes" do
      unit_type = plot.unit_type
      finish_category = create(:finish_category, name: "Test category")
      finish_type = create(:finish_type, name: "Test type", finish_categories: [finish_category])
      finish = create(:finish, finish_category: finish_category, finish_type: finish_type)
      create(:room, unit_type: unit_type, finishes: [finish])

      expect(subject).to be_able_to(:read, finish)
    end

    it "has READ access to the plots rooms appliances" do
      unit_type = plot.unit_type
      room = create(:room, unit_type: unit_type)
      appliance_manufacturer = create(:appliance_manufacturer)
      appliance = create(:appliance, appliance_manufacturer: appliance_manufacturer)
      room.appliances << appliance

      expect(subject).to be_able_to(:read, appliance)
    end
  end

  context "with a residency under a division" do
    let(:current_resident) { create(:resident) }
    let(:division_development) { create(:division_development) }
    let(:division_plot) { create(:plot, development: division_development) }
    let(:plot_residency) { create(:plot_residency, plot_id: division_plot.id, resident_id: resident.id) }
    subject { Ability.new(current_resident, division_plot) }

    it "has READ access to a plots division" do
      division = division_development.division

      expect(subject).to be_able_to(:read, division)
    end

    it "has READ access to a plots development" do
      expect(subject).to be_able_to(:read, division_development)
    end
  end

  context "with a residency under a phase plot" do
    let(:current_resident) { create(:resident) }
    let(:phase_plot) { create(:phase_plot) }
    let(:plot_residency) { create(:plot_residency, plot_id: phase_plot.id, resident_id: resident.id) }
    subject { Ability.new(current_resident, phase_plot) }

    it "has READ access to a plots developer" do
      developer = phase_plot.developer

      expect(subject).to be_able_to(:read, developer)
    end

    it "has READ access to a plots phase" do
      phase = phase_plot.phase

      expect(subject).to be_able_to(:read, phase)
    end

    it "has READ access to a phase documents" do
      phase = phase_plot.phase
      document = build(:document, documentable: phase)

      expect(subject).to be_able_to(:read, document)
    end

    it "has READ access to its plot" do
      expect(subject).to be_able_to(:read, phase_plot)
    end

    it "does not have access to other plots" do
      plot2 = create(:plot, phase: phase_plot.phase)
      expect(subject).not_to be_able_to(:read, plot2)
    end

    context "and a division" do
      let(:division_development) { create(:division_development) }
      let(:phase) { create(:phase, development: division_development) }
      let(:division_phase_plot) { create(:phase_plot, phase: phase) }
      let(:plot_residency) { create(:plot_residency, plot_id: division_phase_plot.id, resident_id: resident.id) }
      subject { Ability.new(current_resident, division_phase_plot) }

      it "has READ access to a plots division" do
        division = division_development.division

        expect(subject).to be_able_to(:read, division)
      end
    end
  end

  describe "notifications" do
    subject { Ability.new(current_resident, plot) }
    let(:current_resident) { create(:resident, :with_residency) }
    let(:plot) { current_resident.plots.first }

    it_behaves_like "it can read polymorphic models associated with the residency", Notification, :send_to

    context "when a notifications plot range includes my plot number" do
      it "should allow me to read the notification" do
        notification = create(:notification, send_to: plot.development, plot_numbers: [plot.number])
        expect(subject).to be_able_to(:read, notification)
      end
    end

    context "when a notifications plot range does not include my plot number" do
      it "should not allow me to read the notification" do
        other_plot = create(:plot, development: plot.development)
        notification = create(:notification, send_to: plot.development, plot_numbers: [other_plot.number])

        expect(subject).not_to be_able_to(:read, notification)
      end
    end
  end

  describe "contacts and faqs" do
    subject { Ability.new(current_resident, plot) }
    let(:current_resident) { create(:resident, :with_residency) }
    let(:plot) { current_resident.plots.first }

    context "when there are developers" do
      it "has READ access to its own developer contacts and faqs" do
        readable_contact = create(:contact, contactable: plot.developer)
        readable_faq = create(:faq, faqable: plot.developer)

        expect(subject).to be_able_to(:read, readable_contact)
        expect(subject).to be_able_to(:read, readable_faq)
      end

      it "does NOT have read access to other developer contacts and faqs" do
        another_developer = create(:developer)
        non_readable_contact = create(:contact, contactable: another_developer)
        non_readable_faq = create(:faq, faqable: another_developer)

        expect(subject).not_to be_able_to(:read, non_readable_contact)
        expect(subject).not_to be_able_to(:read, non_readable_faq)
      end
    end

    context "when there are divisions" do
      let(:division) { create(:division, developer: plot.developer) }
      let(:development) { create(:development, division: division) }
      let(:division_plot) { create(:plot, development: development) }
      let(:division_resident) { create(:resident, plot: division_plot) }

      it "has READ access to its own division contacts and faqs" do
        readable_contact = create(:contact, contactable: division)
        readable_faq = create(:faq, faqable: division)

        expect(Ability.new(division_resident, division_plot)).to be_able_to(:read, readable_contact)
        expect(Ability.new(division_resident, division_plot)).to be_able_to(:read, readable_faq)
      end

      it "does NOT have read access to other division contacts and faqs" do
        another_division = create(:division, developer: plot.developer)
        non_readable_contact = create(:contact, contactable: another_division)
        non_readable_faq = create(:faq, faqable: another_division)

        expect(Ability.new(division_resident, division_plot)).not_to be_able_to(:read, non_readable_contact)
        expect(Ability.new(division_resident, division_plot)).not_to be_able_to(:read, non_readable_faq)
      end
    end

    context "when there are developments" do
      it "has READ access to its own development contacts and faqs" do
        readable_contact = create(:contact, contactable: plot.development)
        readable_faq = create(:faq, faqable: plot.development)

        expect(subject).to be_able_to(:read, readable_contact)
        expect(subject).to be_able_to(:read, readable_faq)
      end

      it "does NOT have read access to other development contacts" do
        another_development = create(:development, developer: plot.developer)
        non_readable_contact = create(:contact, contactable: another_development)
        non_readable_faq = create(:faq, faqable: another_development)

        expect(subject).not_to be_able_to(:read, non_readable_contact)
        expect(subject).not_to be_able_to(:read, non_readable_faq)
      end
    end
  end
end
