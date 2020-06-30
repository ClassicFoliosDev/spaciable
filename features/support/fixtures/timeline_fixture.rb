# frozen_string_literal: true

module TimelineFixture
  module_function

  def england
    "England"
  end

  def scotland
    "Scotland"
  end

  def england_copy
    england + " (copy)"
  end

  def timeline_task(title)
    tasks.select{ |t| t[:title] == title}.first
  end

  def tasks
    [{title: "First", question: "Do you want to go first?",
      answer: "nope", stage_id: 1, positive: "da", negative: "niet",
      response: "try doing this"
     },
     {title: "Second", question: "Do you want to go Second?",
      answer: "ok", stage_id: 1, positive: "oui", negative: "non",
      response: "&lt;developer&gt; &lt;development&gt; &lt;phase&gt;",
      feature: {
      title: "Featured",
      precis: "<house_number>",
      description: "<first_name> <last_name>",
      link: "http://thebombles.com"}
     },
     {title: "Third", question: "Do you want me to go third?",
      answer: "not really", stage_id: 1, positive: "si", negative: "no",
      response: "have you thought of doing something else",
      action: {
      title: "Time for Action",
      link: "http://hovis.com"}
     },
     {title: "Forth", question: "What it all 4?",
      answer: "who knows", stage_id: 2, positive: "ja", negative: "nei",
      response: "help is at hand"
     },
     {title: "Fifth", question: "Number 5 is alive?",
      answer: "not", stage_id: 2, positive: "tak", negative: "ni",
      response: "this will fix it"
     },
     {title: "Sixth", question: "What is half a dozen?",
      answer: "6", stage_id: 3, positive: "yebo", negative: "cha",
      response: "We've heard this works"
     },
     {title: "Seventh", question: "How many deady sins are there?",
      answer: "7", stage_id: 3, positive: "etiam", negative: "nihil",
      response: "Definately don't do this"
     },
     {title: "Eigth", question: "What is 12 minus 4?",
      answer: "8", stage_id: 4, positive: "ye", negative: "ani",
      response: "This is goingf to tickle"
     },
     {title: "Ninth", question: "What is no in German?",
      answer: "9", stage_id: 4, positive: "igen", negative: "nem",
      response: "Simples"
     },
     {title: "Tenth", question: "What is a perfect score?",
      answer: "10", stage_id: 4, positive: "ja", negative: "nien",
      response: "This is impossible"
     },
     {title: "Fifty", question: "is it the new 20?",
      answer: "dont be stupid", stage_id: 2, positive: "OK", negative: "Not OK",
      response: "Dont fool yourself",
      feature: {
      title: "Featured",
      precis: "hello",
      description: "who really cares",
      link: "http://thewombles.com"},
      action: {
      title: "Time for Action",
      link: "http://hovis.com"}
    }]
  end

  def finale
    { content: { complete_message: "You are finnished",
                 incomplete_message: "You haven't finished"},
      updated: { omplete_message: "You are sooo finnished",
                 incomplete_message: "You sooo haven't finished"}
    }
  end

  def create_timeline(name, klass)
    timeline = Timeline.create(timelineable: klass,
                               title: name)

    how_tos = Shortcut.find_by(shortcut_type: :how_tos)
    faqs = Shortcut.find_by(shortcut_type: :faqs)
    services = Shortcut.find_by(shortcut_type: :services)
    area_guide = Shortcut.find_by(shortcut_type: :area_guide)

    prev_task = nil
    prev_stage = 0
    tasks.each do |task|
      next if task == tasks.last
      this_task = Task.create(title: task[:title],
                              question: task[:question],
                              answer: task[:answer],
                              response: task[:response],
                              timeline: timeline,
                              stage_id: task[:stage_id],
                              positive: task[:positive],
                              negative: task[:negative],
                              head: task[:stage_id] != prev_stage)

      TaskShortcut.create(task: this_task, shortcut: how_tos, live:true, order: 1)
      TaskShortcut.create(task: this_task, shortcut: faqs, live:true, order: 2)
      TaskShortcut.create(task: this_task, shortcut: services, live:true, order: 3)
      TaskShortcut.create(task: this_task, shortcut: area_guide, live:true, order: 4)

      if task[:action]
        Action.create(task: this_task,
                      title: task[:action][:title],
                      link: task[:action][:link])
      end

      if task[:feature]
        Feature.create(task: this_task,
                       title: task[:feature][:title],
                       precis: task[:feature][:precis],
                       description: task[:feature][:description],
                       link: task[:feature][:link])
      end


      prev_task.update_attributes(next_id: this_task.id) if prev_task

      prev_task = this_task
      prev_stage = task[:stage_id]
    end


    new_finale = Finale.create(complete_message: finale[:content][:complete_message],
                               incomplete_message: finale[:content][:incomplete_message])
    timeline.update_attributes(finale: new_finale)
  end

  def seed_timeline
    load Rails.root.join("db/seeds", "timeline.rb")
    load Rails.root.join("db/seeds", "lookups.rb")
  end

end
