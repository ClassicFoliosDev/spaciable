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

  it "cannot read documents for someone else's plot" do
    document = create(:document, documentable: create(:plot, development: plot.development))
    expect(subject).not_to be_able_to(:read, document)
  end

  it "cannot read documents for someone else's phase plot" do
    document = create(:document, documentable: create(:plot, phase: plot.phase))
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
    document = create(:document, documentable: unit_type)

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
    finish_type = create(:finish_type, name: "Test type", finish_category_id: finish_category.id)
    finish = create(:finish, finish_category: finish_category, finish_type: finish_type)
    create(:room, unit_type: unit_type, finishes: [finish])

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

    it "has READ access to a phase documents" do
      phase = plot.phase
      document = create(:document, documentable: phase)

      expect(subject).to be_able_to(:read, document)
    end

    it "has READ access to its plot" do
      expect(subject).to be_able_to(:read, plot)
    end

    it "does not have access to other plots" do
      plot2 = create(:plot, phase: plot.phase)
      expect(subject).not_to be_able_to(:read, plot2)
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

  describe "notifications" do
    it_behaves_like "it can read polymorphic models associated with the residency", Notification, :send_to

    context "when a notifications plot range includes my plot number" do
      it "should allow me to read the notification" do
        plot = current_resident.plot
        notification = create(:notification, send_to: plot.development, plot_numbers: [plot.number])
        expect(subject).to be_able_to(:read, notification)
      end
    end

    context "when a notifications plot range does not include my plot number" do
      it "should not allow me to read the notification" do
        plot = current_resident.plot
        other_plot = create(:plot, development: plot.development)
        notification = create(:notification, send_to: plot.development, plot_numbers: [other_plot.number])

        expect(subject).not_to be_able_to(:read, notification)
      end
    end
  end
end
