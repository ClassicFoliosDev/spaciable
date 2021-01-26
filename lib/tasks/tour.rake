# frozen_string_literal: true

namespace :tour do
  desc "Load Tour steps"
  task initialise: :environment do
    init_tour
  end

  def init_tour
    [
      [
        ".burger-navigation",
        "Behold! Click on the Menu to view links to all the fantastic features available to you.",
        :left
      ],
      [
        ".view-my-home-btn",
        "Want to dive deeper into your home's specifics? This area is for your important documents and key details about your property.",
        :top
      ],
      [
        ".faqs-component",
        "If you've got any questions about your home, you're probably not alone! Head over to the FAQs section to expand your knowledge and level up as a homeowner.",
        :top
      ],
      [
        ".contacts-component",
        "Here you'll find details of any contact you might need, so you don't have to listen to (as many) crackly covers of pop songs while on hold!",
        :top
      ],
      [
        ".library-component",
        "The library is home to some of the greatest works of modern literature - no, not The Great Gatsby, but your oven's user manual and your Energy Performance Certificate.",
        :top
      ],
      [
        ".perks-component",
        "It pays to be part of a club. Here at Buyers' Club, you'll have access to exciting exclusive offers and discounts, so you can grab some great bargains for your new home.",
        :top
      ],
      [
        ".services-component",
        "Services offers exclusive quotes for a range of services and products, including utility suppliers, landscapers and insurance providers.",
        :top
      ],
      [
        ".area_guide-component",
        "Area Guide displays your closest amenities and services, so you can quickly integrate yourself into the local community.",
        :top
      ],
      [
        ".referrals-component",
        "Sharing is caring!  Fill in this quick and easy form to share your friend’s contact details with your developer.",
        :top
      ],
      [
        ".home_designer-component",
        "Simply upload or recreate your home's floor plans and use your digital canvas to experiment with layout and colour schemes!",
        :top
      ],
      [
        ".issues-component",
        "For any defects that aren't emergencies, you can report them here, creating a ticket with the developer, so you can monitor progress until it's rectified.",
        :top
      ],
      [
        ".snagging-component",
        "You will likely have been told about a snagging period: a window during which you can report any cosmetic defects that you have spotted since moving in that were missed during the inspection, such as scuffed paintwork or damage to skirting boards.",
        :top
      ],
      [
        ".timeline-component",
        "This is your visual tour guide from reservation to completion and beyond.",
        :top
      ],
      [
        ".reservation-component",
        "Your reservation manual is an expertly written guide to the buying process, ensuring you know what to expect at each stage.",
        :top
      ],
      [
        ".completion-component",
        "Your completion manual will give you the low-down on how to make the most of your new home, report defects and emergencies, and keep it looking spick-and-span for years to come!",
        :top
      ]
    ].each_with_index do |guide, index|
      TourStep.create!(sequence: index,
                       selector: guide[0],
                       intro: guide[1],
                       position: guide[2])
    end
  end
end
