# frozen_string_literal: true

namespace :timeline do
  desc "Reset the ts and cs status for all residents"
  task load: :environment do

    TaskLog.delete_all
    PlotTimeline.delete_all
    TaskShortcut.delete_all
    Shortcut.delete_all
    Action.delete_all
    TimelineTask.delete_all
    Task.delete_all
    TimelineStage.delete_all
    Stage.delete_all
    Timeline.delete_all

    how_to = Shortcut.create(shortcut_type: :how_tos, link: "homeowner_how_tos_path")
    faqs = Shortcut.create(shortcut_type: :faqs, link: "homeowner_faqs_path")
    services = Shortcut.create(shortcut_type: :services, link: "services_path")
    area_guide = Shortcut.create(shortcut_type: :area_guide, link: "services_path")

    timeline = Timeline.create(title: 'England')
    reservation = Stage.create(title: 'Reservation', description: 'A reservation description')
    exchange = Stage.create(title: 'Exchange', description: 'A exchange description')
    moving = Stage.create(title: 'Moving', description: 'A moving description')
    living = Stage.create(title: 'Living', description: 'A living description')

    TimelineStage.create(timeline: timeline, stage: reservation, order: 1)
    TimelineStage.create(timeline: timeline, stage: exchange, order: 2)
    TimelineStage.create(timeline: timeline, stage: moving, order: 3)
    TimelineStage.create(timeline: timeline, stage: living, order: 4)

    ##############################################################

    task = Task.create(title: 'Reservation Fees',
                       question: "Nice easy question to start – have you paid your reservation fee?",
                       answer: "Pay the reservation fee to start your home buying journey...",
                       response:
"Paying your reservation fee will get the ball rolling and you’ll be on the path to becoming a homeowner with <<developer name>>, kickstarting an exciting new chapter in your life.

If you have any questions at this stage, please don’t hesitate to contact our Sales Negotiator, who will be more than happy to guide you through the process.

Once you have paid the reservation fee, you can begin the 21 day countdown to exchange of contracts!")

    previous_timeline_task = TimelineTask.create(timeline: timeline,
                                                 stage: reservation,
                                                 task: task,
                                                 head: true)

    TaskShortcut.create(task: task, shortcut: how_to)
    TaskShortcut.create(task: task, shortcut: faqs)
    TaskShortcut.create(task: task, shortcut: services)
    TaskShortcut.create(task: task, shortcut: area_guide)

    ##############################################################

    task = Task.create(title: 'Solicitor/Conveyencer',
                       question: "The first thing you will need to do now is appoint a Solicitor/Conveyencer.  Have you done this yet?",
                       answer: "Appointing a Solicitor/Conveyancer ",
                       response:
"Solicitors and Conveyancers speak their own language full of words that sound like they come from a children’s book, like ‘gazumping’, ‘gazundering’ and, erm, ‘early repayment charge’.

At the same time, they do wear nice suits and these words are clearly very important.
More important, however, is that you appoint your Solicitor or Conveyancer to kickstart the purchasing your process.  They will act as your mouthpiece and translator, so you don’t have to worry about carrying a glossary around at all times (though if you really want to show off to your Solicitor, a useful glossary can be found here (link to glossary)*.

For the more exotically inclined, who see the buying process as an adventure, they are also your tour guide, safely steering you through the buying process, across the jungle of jargon and out of the contract caverns, while prioritising your best interests.

After appointing your legal representatives, please let your Sales Negotiator know, so they can get the exciting part underway!")

    this_timeline_task = TimelineTask.create(timeline: timeline,
                                             stage: reservation,
                                             task: task)

    previous_timeline_task.update_attribute(:next, this_timeline_task)
    previous_timeline_task = this_timeline_task

    TaskShortcut.create(task: task, shortcut: how_to)
    TaskShortcut.create(task: task, shortcut: faqs)

    Action.create(task: task,
                  action_type: :feature,
                  title: "Find Solicitors",
                  description: "Spaciable services can help youfind a solicitor if you have not found one at this stage",
                  link: "https://www.thelawsuperstore.co.uk/?gclid=EAIaIQobChMI0OnG86vv6AIVSbTtCh07qAPbEAAYASAAEgIjgvD_BwE&ef_id=EAIaIQobChMI0OnG86vv6AIVSbTtCh07qAPbEAAYASAAEgIjgvD_BwE:G:s&refId=ggle_zso")


    ##############################################################

    task = Task.create(title: 'Mortgage Offer',
                       question: "Have you got a mortgage in principle?",
                       answer: "Arranging your mortgage",
                       not_applicable: true,
                       response:
"Okay, so maybe it’s not quite time to start the exciting bit just yet.

There’s still the matter of securing the money.

Speaking to an independent financial advisor (IFA) is the best way to ensure you get the best loan for your situation.  As much as we may read about the strength of the property market, IFAs really have their finger on the pulse and can provide invaluable unbiased, advice.

You'll need to bear in mind that mortgage lenders will need proof of buildings insurance, if this hasn't already been arranged.

Between selecting a mortgage, submitting supporting documents and receiving approval, this part of the process can involve a lot of thumb twiddling, and should therefore be started as soon as possible.

Depending on your filing efficiency, you may also need to start frantically emptying drawers, pulling up floorboards, digging under the shed, etc., to find the payslips, proof of residence, ID and loan details required by the lender.

Once you have received confirmation of your mortgage offer, your Solicitor will be advised so they can shout from the rooftops* that you are in a position to exchange contracts.")

    this_timeline_task = TimelineTask.create(timeline: timeline,
                                             stage: reservation,
                                             task: task)

    previous_timeline_task.update_attribute(:next, this_timeline_task)
    previous_timeline_task = this_timeline_task

    TaskShortcut.create(task: task, shortcut: services)
    TaskShortcut.create(task: task, shortcut: area_guide)

    Action.create(task: task,
                  action_type: :action,
                  title: "Get Quote",
                  link: "https://www.localadvisors.co.uk/find-mortgage-advisors/?gclid=EAIaIQobChMIiIDIi6zv6AIVw7HtCh0XkAUyEAAYAyAAEgJ07PD_BwE")

    ##############################################################

    task = Task.create(title: 'Fees',
                       question: "Have you completed the initial forms from your Solicitor and paid any necessary fees?",
                       answer: "Initial legal paperwork and fees",
                       response:
"Solicitors can be a demanding breed and will have sent you paperwork to review, complete and return.

You may sigh at the sight of pages and pages of less than thrilling literature but just think of the end-goal!

So, relish every word on those pages as if they were written by Charles Dickens himself, just with a bit of added jargon!  Don't worry though, you can find a useful glossary here.

As well as returning the paperwork, you will be required to provide the Solicitor with official identification as part of Anti-Money Laundering Regulations.  Two forms of ID must be provided for each buyer: a photographic ID, such as a passport or driving licence, and a proof of address from the previous three months, such as a utility bill or bank statement.

At this point, you should also make sure you have paid any outstanding fees, including the local search fees that check there are no issues, such as planned works, in the local area that could affect the value of your property.  The search results are usually payable in advance and are required by mortgage lenders.

If you are expecting any documents from the developer, they may be uploaded to your  Library, which you can find here.  You can sign these electronically, using DocuSign.

If you have any questions about the forms, contact your Solicitor.")

    this_timeline_task = TimelineTask.create(timeline: timeline,
                                             stage: reservation,
                                             task: task)

    previous_timeline_task.update_attribute(:next, this_timeline_task)
    previous_timeline_task = this_timeline_task

    TaskShortcut.create(task: task, shortcut: services)
    TaskShortcut.create(task: task, shortcut: area_guide)

    task = Task.create(title: 'Draft Contract',
                       question: "Have you read through your draft contract and submitted any queries to your Solicitor?",
                       answer: "Reviewing your draft contract and submitting queries",
                       response:
"Is it starting to feel real yet?

Our Solicitor will have provided your Solicitor with a draft of the contract, so the terms and wording can be thrashed out.  Hopefully it won’t be quite that dramatic but this is the ideal opportunity to ask your legal representative for clarification on any points, if for no other reason but to make sure you are getting your money’s worth from the legal fees, and to give your Solicitor a chance to wear their new suit to a meeting.

If you're moving to a new area, now is a good time to start thinking about the local schools.  There's much to consider - the Ofsted ratings, the sports teams, whether the uniform matches the colour scheme in your new lounge.  Luckily, you can find this information using the Area Guide feature - if only they did GCSEs in moving home!")

    this_timeline_task = TimelineTask.create(timeline: timeline,
                                             stage: reservation,
                                             task: task)

    previous_timeline_task.update_attribute(:next, this_timeline_task)
    previous_timeline_task = this_timeline_task

    TaskShortcut.create(task: task, shortcut: services)
    TaskShortcut.create(task: task, shortcut: area_guide)

    Action.create(task: task,
                  action_type: :action,
                  title: "Area Guide",
                  link: "https://www.placebuzz.com/area-guides")

    ##############################################################

    task = Task.create(title: 'Home Tour',
                       question: "Have you been given a tour of your home?",
                       answer: "Taking a home tour",
                       response:
"Even if your home isn’t built yet, we can still give you a sneak preview of what to expect.  Not only that but you can show your friends, family, pets, barista, et al.

You can also use the Services feature to find exclusive rates for home furnishings and electrical goods!")

    this_timeline_task = TimelineTask.create(timeline: timeline,
                                             stage: reservation,
                                             task: task)

    previous_timeline_task.update_attribute(:next, this_timeline_task)
    previous_timeline_task = this_timeline_task

    TaskShortcut.create(task: task, shortcut: how_to)
    TaskShortcut.create(task: task, shortcut: faqs)
    TaskShortcut.create(task: task, shortcut: services)
    TaskShortcut.create(task: task, shortcut: area_guide)

    Action.create(task: task,
                  action_type: :action,
                  title: "Virtual tour",
                  link: "https://go.matterport.com/PPC-FY20-EMEA-Architecture_RRE.html?utm_source=google&utm_medium=ppc&utm_campaign=EN_EMEA_UK_PRM&utm_content=419586209250&utm_term=virtual%20home%20tours&matchtype=e&device=c&gclid=EAIaIQobChMI-tv3tqzv6AIVBbDtCh2wowb-EAAYASAAEgLThPD_BwE")

    ##############################################################

    task = Task.create(title: 'Deposit Fees',
                       question: "Have you signed your contract and payed your deposit?",
                       answer: "Time to sign on the dotted line... ",
                       response:
"If you’re happy everything has been included on the contract and any outstanding queries have been answered, then – drumroll please – you are ready to exchange contracts!

If you have any questions about terminology, check out our handy glossary, here, or speak to your solicitor.

You’ll just need to sign the contact and arrange for the balance of the 10% deposit to be paid.  The remaining balance is £X.XX.

A bit of housekeeping first: all money you have paid under the contract before completion is protected by your new home warranty.

Before putting pen to paper, just remember that this contract is a legally binding agreement for both parties to complete the sale and purchase of the home.  But don’t let that or the stern looking Solicitor put you off.  This is an exciting moment!

If you are expecting any documents from the developer, they may be uploaded to your  Library, which you can find here.  You can sign these electronically, using DocuSign.

And there you have it!  Time to flaunt the news on social media - if ever an Insta-brag was justified, this is it.  Remember to hashtag your developer, Spaciable, your dog and all of the Insta Influencers who have been spamming you with #lifegoals (now is your opportunity for revenge)!")

    this_timeline_task = TimelineTask.create(timeline: timeline,
                                             stage: exchange,
                                             task: task,
                                             head: true)

    previous_timeline_task.update_attribute(:next, this_timeline_task)
    previous_timeline_task = this_timeline_task

    ##############################################################

    task = Task.create(title: 'Choices/Finishes',
                       not_applicable: true,
                       question: "Have you made any available choices and options on the finishes in your home?",
                       answer: "Making your home your own",
                       response:
"Now you are the homeowner elect, you can start adding a personal touch to your home, so when you step through the front door for the first time after completion, you can immediately see your fingerprint.  This is where you start to make your house your home.

The Sales Negotiator will have informed you of the latest date for making your choices, after which time a default selection will be made.  There’s nothing wrong with Default – it’s a perfectly pleasant colour – but there has never been a better time to see the hot pink carpet you have always dreamed of become a reality!

If you want to see how your home could look with different colour schemes and layouts, why not experiment with a digital canvas?  Simply upload your floor plan here and get creative!

For your home, you are able to select the carpet in the bedroom from the Cormar Carpets Primo Plus range.  To do submit your choice, please select from the options below and click submit.

Your choices need to be sumitted by XX/XX/XX.

Please note that once you click submit, your choices are final.  If you need to make any changes, you should contact your Sales Negotiator immediately to discuss the possibility.

(photos and descriptions of each carpet with ability to select one)


SMART HOME UPGRADE POP-UP
You can also add a touch of sci-fi to your home with an incredible smart home package, allowing you to control your lighting, heating, AV system and security from your smartphone – any time, anywhere.

To upgrade your home to include an integrated smart home package, please click here (link to Services).")

    this_timeline_task = TimelineTask.create(timeline: timeline,
                                             stage: exchange,
                                             task: task)

    previous_timeline_task.update_attribute(:next, this_timeline_task)
    previous_timeline_task = this_timeline_task

    ##############################################################

    task = Task.create(title: 'Contracts',
                       question: "Has your Solicitor exchanged contracts?",
                       answer: "Awaiting exchange contracts",
                       response:
"There are a number of moving parts at this stage, which may slightly delay the exchange of contracts but don’t fear!

Your Solicitor should keep you informed of any potential hold-ups at this point, which may depend on the releasing of the deposit.

They will then send the Title Deeds and a request for the mortgage advance to your lender, if applicable, before registering the transfer of ownership with the Land Registry.
It’s not the most thrilling part of the process and you should be grateful that most of this is happening behind the scenes.

Remember to make use of the glossary, if necessary!

Why not use this time to get the wheels in motion for the big day?  Have a look at the Services feature to find exclusive offers from recommended service suppliers, such as removals, insurance, will writing, home care packages and utility suppliers.  You can even find property management companies, if you're planning on letting out your home!")

    this_timeline_task = TimelineTask.create(timeline: timeline,
                                             stage: exchange,
                                             task: task)

    previous_timeline_task.update_attribute(:next, this_timeline_task)
    previous_timeline_task = this_timeline_task

    TaskShortcut.create(task: task, shortcut: how_to)
    TaskShortcut.create(task: task, shortcut: faqs)
    TaskShortcut.create(task: task, shortcut: services)
    TaskShortcut.create(task: task, shortcut: area_guide)

    ##############################################################

    task = Task.create(title: 'Home Demonstration',
                       question: "Has your Sales Negotiator contacted you to arrange a Home Demonstration?",
                       answer: "Arranging your Home Demonstration",
                       response:
"Your Sales Negotiator will contact you to set aside a couple of hours for a Home Demonstration, so you can be shown all of the bells and whistles of your new home.

This will take place during our normal working hours (please double check these with us) and will usually involve a member of the Sales Team and the Site Manager.

Much like a city tour, except instead of historic bridges and murals, you will be shown the locations of equally exciting meters and stopcocks.

Don't worry if you miss anything, as <<developer name>> has kindly provided you with access to an on-demand virtual tour of your home, with embedded videos demonstrating how various appliances as work.  Simply look at your oven and an instructional video will appear before your very eyes.  Sorcery at its absolute finest.

Pop-up Message
Please bear in mind that your Home Demonstration presents an ideal opportunity to ask any questions you may have about your home’s fixtures, fittings and systems.  It may be an idea to write down any questions beforehand, so you don’t miss anything!")

    this_timeline_task = TimelineTask.create(timeline: timeline,
                                             stage: exchange,
                                             task: task)

    previous_timeline_task.update_attribute(:next, this_timeline_task)
    previous_timeline_task = this_timeline_task

    ##############################################################

    task = Task.create(title: 'Home Insurance',
                       question: "Have you arranged home insurance?",
                       answer: "Ensure you're insured!",
                       response:
"The importance of this stage can’t be overstated.  Following exchange of contracts, you are liable for the property and will need to have buildings and contents insurance in place.

We’ve heard some horror stories of disaster striking during even the briefest of windows in which a property is uninsured.  Don’t let this happen to you and make sure you are insured at your current abode and your new home for the entirety of the time you are legally recognised as the owner.

Our partnered insurance providers can help ensure (no pun intended) you are covered at all times.")

    this_timeline_task = TimelineTask.create(timeline: timeline,
                                             stage: moving,
                                             task: task,
                                             head: true)

    previous_timeline_task.update_attribute(:next, this_timeline_task)
    previous_timeline_task = this_timeline_task

    TaskShortcut.create(task: task, shortcut: how_to)
    TaskShortcut.create(task: task, shortcut: faqs)
    TaskShortcut.create(task: task, shortcut: services)
    TaskShortcut.create(task: task, shortcut: area_guide)

    ##############################################################

    task = Task.create(title: 'Utilities',
                       question: "Have you taken meter readings at your old (where applicable) and new properties?",
                       answer: "Remember to take your meter readings",
                       response:
"Amidst all of the excitement of moving day, it can be easy to forget the brown box on the side of your home, only to be brutally reminded of it six months later when your old energy supplier sends you an unfamiliar looking bill.

So, here is your friendly reminder to take your meter readings when you move out of your old home.  It might also be an idea to take a photograph, so you have something tangible to refer back to if any issues arise.  Contact your existing providers with the reading to close the account.

Likewise, take the meter readings upon arrival at your new home, then enter your details in each of the following form.  By clicking Submit, these will be automatically forwarded to your utility provider, saving you the unenviable task of listening to high pitched hold music for 22 minutes.")

    this_timeline_task = TimelineTask.create(timeline: timeline,
                                             stage: moving,
                                             task: task)

    previous_timeline_task.update_attribute(:next, this_timeline_task)
    previous_timeline_task = this_timeline_task

    TaskShortcut.create(task: task, shortcut: how_to)
    TaskShortcut.create(task: task, shortcut: faqs)
    TaskShortcut.create(task: task, shortcut: services)
    TaskShortcut.create(task: task, shortcut: area_guide)

    ##############################################################

    task = Task.create(title: 'Council',
                       question: "Have you contacted the Local Authority to arrange council tax and register to vote?",
                       answer: "Registering with the local council",
                       response:
"Before saying hello to the family next door, why not practice your neighbourly charm on your local authority?

Nothing makes you feel part of the community quite like arranging payment of council tax!

Even if you are staying in the same area, you will need to inform the council of your change of address. (include button to fill out council tax application)

If you’re moving to a new area, don’t forget to let your current council know, otherwise you may still be billed at your previous address!

You will also need to register to vote in the local elections in order to have any right to complain about the outcomes.

If you haven’t been provided with refuse and recycling bins at your new home, these can be requested from the council, here.")

    this_timeline_task = TimelineTask.create(timeline: timeline,
                                             stage: moving,
                                             task: task)

    previous_timeline_task.update_attribute(:next, this_timeline_task)
    previous_timeline_task = this_timeline_task

    TaskShortcut.create(task: task, shortcut: how_to)
    TaskShortcut.create(task: task, shortcut: faqs)
    TaskShortcut.create(task: task, shortcut: services)
    TaskShortcut.create(task: task, shortcut: area_guide)

    ##############################################################

    task = Task.create(title: 'Local Area',
                       question: "It’s been quite the journey, hasn’t it?  Why not celebrate with a drink at your local pub?",
                       answer: "Finding your new local haunts",
                       response:
"Area Guide will show you the closest pubs to your new home (as well as an extensive range of other, non-alcoholic amenities!), so you can easily seek out your new ‘local’.

It may feel like a minor thing to consider at this stage but don't discount the importance of flashing your pearly whites at your new neighbours.  Use your Area Guide to find local dentists and check their ratings (so you don't end up with Dr. Dastardly manhandling your molars).

And then there's the small matter of your first meal in your new home!  Beans on toast is no way to celebrate - check out your nearest supermarket and go for something a bit more gourmet!

Familiarise yourself with your new surroundings here and become a fully-fledged member of the community!")

    this_timeline_task = TimelineTask.create(timeline: timeline,
                                             stage: living,
                                             task: task,
                                             head: true)

    previous_timeline_task.update_attribute(:next, this_timeline_task)
    previous_timeline_task = this_timeline_task

    TaskShortcut.create(task: task, shortcut: how_to)
    TaskShortcut.create(task: task, shortcut: faqs)
    TaskShortcut.create(task: task, shortcut: services)
    TaskShortcut.create(task: task, shortcut: area_guide)

    ##############################################################

    task = Task.create(title: 'Snags',
                       question: "Don't forget to submit your Cosmetic Inspection form!",
                       answer: "Searching for any snags",
                       response:
"Although we will have endeavoured to make sure your home meets the pristine standard we set, some minor issues might have sneaked past us, with ninja-like powers of evasion.  The Cosmetic Inspection is your opportunity to flag any such cosmetic damage, including marks, scratches, chips and dents.

These items can be submitted here. ")

    this_timeline_task = TimelineTask.create(timeline: timeline,
                                             stage: living,
                                             task: task)

    previous_timeline_task.update_attribute(:next, this_timeline_task)
    previous_timeline_task = this_timeline_task

    TaskShortcut.create(task: task, shortcut: how_to)
    TaskShortcut.create(task: task, shortcut: faqs)
    TaskShortcut.create(task: task, shortcut: services)
    TaskShortcut.create(task: task, shortcut: area_guide)

    ######################### plot timeline ######################

    PlotTimeline.create(timeline: timeline,
                        plot: Plot.find_by(number: 'Timeline'))

    ##############################################################

  end
end
