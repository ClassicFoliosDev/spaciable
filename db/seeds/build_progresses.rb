updated_progresses = { exchange: [3, 12], comp_ready: [4, 13], comp: [5, 14], none: [6, 15] }

updated_progresses.each do |progress|
  Plot.where(progress: progress[1][0]).each do |plot|
    plot.update_attributes(progress: progress[1][1])
  end
end
