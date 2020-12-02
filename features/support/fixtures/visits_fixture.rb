# frozen_string_literal: true

# rubocop:disable ModuleLength
# Method needs refactoring see HOOZ-232
module VisitsFixture
  module_function

  DEVELOPER = ["Bovis Region #", :company_name]
  DEVELOPMENT = ["Alpha #", :name]
  PHASE = ["Phase #", :name]
  PLOT = ["Flat #", :number]
  RESIDENT = ["res@gmail#.com", :email]
  NUM_DEVELOPERS = 2
  NUM_DEVELOPMENTS = 2

  class << self; attr_accessor :expected; end

  (1..NUM_DEVELOPERS).each do |dev|
    ["developer", "development", "phase", "plot", "resident"].each do |t|
      # create accessor for name e.g. developer1_name
      define_method "#{t}#{dev}_name" do
        "#{const_get(t.upcase)[0]}#{dev}"
      end

      # create accessor for instance e.g. developer1
      define_method "#{t}#{dev}" do
        t.capitalize().classify
         .constantize.find_by(const_get(t.upcase)[1] => send("#{t}#{dev}_name"))
      end
    end

    (1..NUM_DEVELOPMENTS).each do |dvmt|
      ["development", "phase", "plot", "resident"].each do |t|
        # create accessor for name e.g. developer1_name
        define_method "#{t}#{dev}_#{dvmt}_name" do
          const_get(t.upcase)[0].dup.sub! "#", "#{dev}#{dvmt}"
        end

        # create accessor for instance e.g. developer1_1
        define_method "#{t}#{dev}_#{dvmt}" do
          t.capitalize().classify
           .constantize.find_by(const_get(t.upcase)[1] => send("#{t}#{dev}_#{dvmt}_name"))
        end
      end
    end
  end

  def create_residents
    FaqsFixture.create_faq_ref
    CreateFixture.create_how_tos

    (1..NUM_DEVELOPERS).each do |d|
      CreateFixture.create_developer(name: send("developer#{d}_name"))
      MyHomeFaqsFixture.create_faqs(faqable: send("developer#{d}"))

      create_contacts(send("developer#{d}"))

      (1..NUM_DEVELOPERS).each do |v|
        CreateFixture.create_development(name: send("development#{d}_#{v}_name"),
                                         dev: send("developer#{d}"))
        send("development#{d}_#{v}").update_attributes(enable_snagging: true,
                                                       snag_duration: 300)
        MyLibraryFixture.create_documents(documentable: send("development#{d}_#{v}"))

        phase = CreateFixture.create_development_phase(name: send("phase#{d}_#{v}_name"),
                                               dev: send("development#{d}_#{v}"),
                                               business: v)
        CreateFixture.create_unit_type(dev: send("development#{d}_#{v}"), link: "http://youtube")
        CreateFixture.create_phase_plot(send("phase#{d}_#{v}"),
                                        number: send("plot#{d}_#{v}_name"))
        CreateFixture.create_resident(send("resident#{d}_#{v}_name"),
                                      plot: send("plot#{d}_#{v}"))

        phase_timeline = PhaseTimeline.create(phase: phase, timeline: Timeline.first)

        PlotTimeline.create(phase_timeline: phase_timeline, plot: send("plot#{d}_#{v}"))

        # ensure the plots are completed
        send("plot#{d}_#{v}").update_attributes(completion_release_date: Time.zone.now - 1.week,
                                                completion_date: Time.zone.now - 2.week,
                                               )
      end
    end
  end

  def create_contacts(developer)
    Contact.categories.each do |name, _|
      FactoryGirl.create(:contact, contactable: developer, category: name)
    end
  end

  def visited(plot, *params)
    @expected ||= {}
    params.map! { |p| (p.is_a? Symbol) ? I18n.t("ahoy.#{p}") : p }
    expect(plot, @expected, params, 0)
  end

  # This is a bit complicated.  @expected is recursively
  # constructed to record the numbers of visits and
  # unique visits for a set of parameters (represented by
  # the same hash value that VisitorFilter will generate
  # for the equivalent entry in the html table) so that all
  # expected visits can be checked agains the generated results
  def expect(meta, results, params, level=0)
    return unless level < params.count
    h = VisitorFilter.hash(params[0..level])
    results[h] ||= {visits: []}
    results[h][:visits] << meta
    expect(meta, results[h], params, level+1) # recurse
  end

end
# rubocop:enable ModuleLength
