$(document).on('click', '.branded-hero', function() {
var tour = introJs()

  tour.setOptions({
    showStepNumbers: false,
    keyboardNavigation: true,
    scrollToElement: true,
    disableInteraction: true,
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
