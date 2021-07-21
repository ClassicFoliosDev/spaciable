Before do
  Global.create(name: "CFAdmin") if Global.first.nil?

  # create the master build sequence
  sequence = BuildSequence.create(build_sequenceable: Global.first)

  Plot.progresses.each do |t, v|
    BuildStep.create(title: I18n.t("activerecord.attributes.plot.progresses.#{t}"),
                     description: I18n.t("activerecord.attributes.plot.progresses.#{t}"),
                     order: v + 1,
                     build_sequence: sequence)
  end
end
