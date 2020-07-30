$(document).on('click', '.branded-hero', function() {
var tour = introJs()

  tour.setOptions({
    showStepNumbers: false,
    keyboardNavigation: true,
    scrollToElement: true,
    disableInteraction: true,
    steps: [
      {
        element: ".burger-navigation",
        intro: "Welcome to your home's personalised portal. You'll find the main menu here, where you can explore all of the features your personal home portal has to offer. You can also access key features from your dashboard, which we'll show you next.",
        position: "bottom"
      },
      {
        element: ".my-home",
        intro: "Here's your new address. Click the 'View My Home' button to see detailed information about your home, such as your finishes and fittings.",
        position: "bottom"
      },
      {
        element: ".switch-plot-btn",
        intro: "You can view all of your plots and swap between them by clicking here.",
        position: "right"
      },
      {
        element: ".faqs-component",
        intro: "Find answers to common questions in your FAQs.",
        position: "top"
      },
      {
        element: ".contacts-component",
        intro: "If you can't find what you're looking for in the FAQs, a selection of useful contacts is available.",
        position: "top"
      },
      {
        element: ".library-component",
        intro: "Useful documents and appliance guides have been uploaded to your library. You can also upload your own documents to keep everything together in one place.",
        position: "bottom"
      },
    ].filter(function (obj) {
      return $(obj.element).length
    })
  })

  tour.start()
})
