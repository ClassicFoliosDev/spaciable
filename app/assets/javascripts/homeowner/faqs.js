document.addEventListener("turbolinks:load", function() {
  var $dashboardFaqs = $("body.homeowner-view .faqs");

  if ($dashboardFaqs.length > 0) {
    var faqAnchor = window.location.hash;
    var $faq = $(faqAnchor);
    var faqIndex = $dashboardFaqs.find("dt").index($faq);

    if (faqIndex > -1) {
      $dashboardFaqs.accordion({ active: faqIndex, heightStyle: 'content'});
      $("body").scrollTop($faq.position().top);
    } else {
      $dashboardFaqs.accordion({ heightStyle: 'content'});
    }
  }
});
