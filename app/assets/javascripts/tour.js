document.addEventListener('turbolinks:load', function () {
  // check the relevant cookie value
  var tourCookie = document.cookie.split('; ')
                                  .find(row => row.startsWith('dashboard_tour'))
  if (tourCookie) { var tourCookieValue = tourCookie.split('=')[1] }

  if ( $("#homeownerDashboard").length && tourCookieValue == "show" ) {
    loadDashboardTour()
  }
})

$(document).on('click', '.introjs-skipbutton', function () {
  // set the cookie to false with an expiry date in the past
  document.cookie = "dashboard_tour=hide; expires=" + new Date(Date.now() - 86400000)
  console.log(document.cookie)
})

$(document).on('click', '.dashboard-tour-link', function () {
  // set the cookie to false with an expiry date in the past
  document.cookie = "dashboard_tour=show; expires=" + new Date(Date.now() + 86400000)
  console.log(document.cookie)
})

function loadDashboardTour() {
  var tour = introJs()

  tour.setOptions({
    showStepNumbers: false,
    keyboardNavigation: true,
    scrollToElement: true,
    disableInteraction: true,
    exitOnOverlayClick: false,
    exitOnEsc: true,
    nextLabel: "Next",
    prevLabel: "Back",
    skipLabel: "Skip Tour",
    steps: [
      {
        element: ".burger-navigation",
        intro: "Behold the wonders of your portal! Click on the Menu to view links to all the fantastic features available to you, helpfully split up into three sections: Essentials, Lifestyle and A Helping Hand. The perfect place to start if you're not quite sure what you're looking for.",
        position: "left"
      },
      {
        element: ".view-my-home-btn",
        intro: "Need to know what the RAL code is for your hallway wall paint? Or the range of the wall tiles in the bathroom? Or do you just need to check the program settings for your oven? You'll find all of this here, along with a range of other documents relating to your home.",
        position: "top"
      },
      {
        element: ".faqs-component",
        intro: "If you've got any questions about your home, you're probably not alone! Head over to the FAQs section to expand your knowledge and level up as a homeowner. Answers to a range of questions can be sorted by category, placing quick and easy explanations at your fingertips!",
        position: "top"
      },
      {
        element: ".contacts-component",
        intro: "Occasionally, you may need to pick up the phone to get to the bottom of an issue. But not many things are more annoying than getting passed from person to person like a game of phone tennis, in search of an answer. In fact, sometimes, just finding a number can be a bit of a mission! Contacts displays customer care, service, sales, management and emergency contacts, so you don't have to listen to (as many) crackly covers of pop songs while on hold!",
        position: "top"
      },
      {
        element: ".library-component",
        intro: "<strong>*Whispering*</strong> The library is home to some of the greatest works of modern literature - no, not The Great Gatsby or To Kill a Mockingbird, but your oven's user manual, your home's structural warranty policy and your Electrical Performance Certificate. Separated by <del>genre</del> category, you will be able to quickly and easily find any of the downloadable documents relating to your home.",
        position: "top"
      },
      {
        element: ".perks-component",
        intro: "It pays to be part of a club. Quite literally in the case of Buyers' Club. Here, you'll have access to exiting exclusive offers and discounts, so you can grab some great bargains for your new home, while walking around with the swagger that comes with being a VIP!",
        position: "top"
      },
      {
        element: ".services-component",
        intro: "The money saving doesn’t stop there, either!  Services offers exclusive quotes for a range of services and products, including utility suppliers, landscapers and insurance providers, so you can start saving for a luxury spa trip to relax after a busy few months – oh, wait – Services can offer discounts on spa trips, too!",
        position: "top"
      },
      {
        element: ".area_guide-component",
        intro: "After moving into your new home, you’ll need to celebrate!  Why not take the opportunity to check out your local bars and restaurants?!  Area Guide displays your closest amenities and services, including retailers, health services, schools and bus stops, so you can quickly integrate yourself into the local community.",
        position: "top"
      },
      {
        element: ".referrals-component",
        intro: "Have you been bowled over by an incredible buying experience?  Well, sharing is caring!  Just fill in this quick and easy form to share your friend’s contact details with your developer, and they may just become your new neighbour!",
        position: "top"
      },
      {
        element: ".home_designer-component",
        intro: "Unleash your inner interior designer!  Simply upload or recreate your home’s floor plans and use your digital canvas to experiment with layout and colour schemes!  No longer do you have to risk whether a paisley sofa will go with navy blue carpets and salmon pink curtains!",
        position: "top"
      },
      {
        element: ".issues-component",
        intro: "Sometimes defects occur in new builds – it’s just one of those things.  For any defects that aren’t emergencies, you can report them here, creating a ticket with the developer, so you can monitor progress until it’s rectified.  If the defect is an emergency, e.g., you find yourself wading through waist-height water to get to the fridge freezer, you’re best off calling your emergency contact!",
        position: "top"
      },
      {
        element: ".snagging-component",
        intro: "You will likely have been told about a snagging period: a window during which you can report any cosmetic defects that you have spotted since moving in that were missed during the inspection, such as scuffed paintwork or damage to skirting boards.  Use this feature to report any items and, like magic*, they’ll be sorted!  Just like voting on The X Factor, the window is open for a limited time only, after which, you’ll be unable to report snagging items.<br/><br/>* An appointment will likely be made to determine a suitable course of action",
        position: "top"
      },
      {
        element: ".reservation-component",
        intro: "Your reservation manual is an expertly written guide to the buying process, ensuring you know what to expect at each stage, keeping things running along smoothly.",
        position: "top"
      },
      {
        element: ".completion-component",
        intro: "You are bound to have plenty of questions after moving into your new home.  Whether it’s to do with ventilating your new home or caring for your worktops (even if that does make them sound a bit like pets), your completion manual will give you the low-down on how to make the most of your new home, report defects and emergencies, and keep it looking spick-and-span for years to come!",
        position: "top"
      },
    ].filter(function (obj) {
      return $(obj.element).length
    })
  })

  tour.start()
}

