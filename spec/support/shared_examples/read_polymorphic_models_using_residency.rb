# frozen_string_literal: true

RSpec.shared_examples "it can read polymorphic models associated with the residency" do |polymorphic_class, association|
  let(:polymorphic_factory_name) { polymorphic_class.model_name.element.to_sym }
  let(:current_resident) { create(:resident, plot: plot) }
  let(:plot) { create(:plot) }

  subject { Ability.new(current_resident, plot: plot) }

  it "can read models for my plot" do
    model = build(polymorphic_factory_name, association => plot)
    expect(subject).to be_able_to(:read, model)
  end

  it "can read models for my development" do
    model = build(polymorphic_factory_name, association => plot.development)
    expect(subject).to be_able_to(:read, model)
  end

  it "can read models for my developer" do
    model = build(polymorphic_factory_name, association => plot.developer)
    expect(subject).to be_able_to(:read, model)
  end

  it "cannot read models under a division" do
    division = create(:division, developer: plot.developer)
    model = build(polymorphic_factory_name, association => division)

    expect(subject).not_to be_able_to(:read, model)
  end

  context "with a residency under a division" do
    let(:division_development) { create(:division_development) }
    let(:plot) { create(:plot, development: division_development) }

    it "can read models for my division" do
      model = build(polymorphic_factory_name, association => division_development.division)
      expect(subject).to be_able_to(:read, model)
    end
  end

  context "with a residency under a phase plot" do
    let(:plot) { create(:phase_plot) }

    it "can read models for my developer" do
      model = build(polymorphic_factory_name, association => plot.developer)
      expect(subject).to be_able_to(:read, model)
    end

    it "can read models for my development" do
      model = build(polymorphic_factory_name, association => plot.development)
      expect(subject).to be_able_to(:read, model)
    end
  end

  context "under a division" do
    let(:division_development) { create(:division_development) }
    let(:phase) { create(:phase, development: division_development) }
    let(:plot) { create(:phase_plot, phase: phase) }

    it "can read models for my division" do
      model = build(polymorphic_factory_name, association => division_development.division)
      expect(subject).to be_able_to(:read, model)
    end
  end
end
