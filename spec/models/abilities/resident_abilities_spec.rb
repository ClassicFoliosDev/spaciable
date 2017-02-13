# frozen_string_literal: true
require "rails_helper"
require "cancan/matchers"

RSpec.describe "Resident Abilities" do
  subject { Ability.new(current_resident) }

  let(:current_resident) { create(:resident, plot: plot) }
  let(:plot) { create(:plot) }

  it "can manage itself" do
    expect(subject).to be_able_to(:manage, current_resident)
  end

  it_behaves_like "it can read polymorphic models associated with the residency", Document, :documentable
  it_behaves_like "it can read polymorphic models associated with the residency", Faq, :faqable
  it_behaves_like "it can read polymorphic models associated with the residency", Contact, :contactable
  it_behaves_like "it can read polymorphic models associated with the residency", Notification, :send_to

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

  it "has READ access to plots unit type" do
    unit_type = plot.unit_type
    raise "unit type is nil" unless unit_type

    expect(subject).to be_able_to(:read, unit_type)
  end

  it "has READ access to the plots unit types rooms" do
    unit_type = plot.unit_type
    room = create(:room, unit_type: unit_type)

    expect(subject).to be_able_to(:read, room)
  end

  it "has READ access to the plots rooms finishes" do
    unit_type = plot.unit_type
    room = create(:room, unit_type: unit_type)
    finish = create(:finish, room: room)

    expect(subject).to be_able_to(:read, finish)
  end

  it "has READ access to the plots rooms appliances" do
    unit_type = plot.unit_type
    room = create(:room, unit_type: unit_type)
    appliance = create(:appliance)
    room.appliances << appliance

    expect(subject).to be_able_to(:read, appliance)
  end

  context "with a residency under a division" do
    let(:division_development) { create(:division_development) }
    let(:plot) { create(:plot, development: division_development) }

    it "has READ access to a plots division" do
      division = division_development.division

      expect(subject).to be_able_to(:read, division)
    end

    it "has READ access to a plots development" do
      expect(subject).to be_able_to(:read, division_development)
    end
  end

  context "with a residency under a phase plot" do
    let(:plot) { create(:phase_plot) }

    it "has READ access to a plots developer" do
      developer = plot.developer

      expect(subject).to be_able_to(:read, developer)
    end

    it "has READ access to a plots phase" do
      phase = plot.phase

      expect(subject).to be_able_to(:read, phase)
    end

    it "has READ access to its plot" do
      expect(subject).to be_able_to(:read, plot)
    end

    context "under a division" do
      let(:division_development) { create(:division_development) }
      let(:phase) { create(:phase, development: division_development) }
      let(:plot) { create(:phase_plot, phase: phase) }

      it "has READ access to a plots division" do
        division = division_development.division

        expect(subject).to be_able_to(:read, division)
      end
    end
  end
end
