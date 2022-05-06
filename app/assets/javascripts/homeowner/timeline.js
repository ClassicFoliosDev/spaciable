(function (document, $) {
  'use strict'

  // select the radio button when clicking on the stage div and add the border
  $(document).on('click', '.timeline-stage-option', function (event) {
    this.firstElementChild.checked = true
    borderSelected()
  })

  $(document).on('click', '#collapse, #expand', function (event) {
    var li = $(this).closest('li')
    li.find('button').toggle()
    li.next('ul').toggle()

    $.post({
      url: "/homeowners/timelines/" + $('#timelineSidebar').data('timeline') + '/collapsed',
      data: {stage: li.data('stage'),
      collapsed: $(this).prop('id') == 'collapse' },
      dataType: 'json'
    })
  })

  // add or remove the 'selected' class from a timeline stage option
  function borderSelected() {
    var allStages = $(".timeline-stage-option")

    for (var i = 0; i < allStages.length; ++i) {
      if (allStages[i].firstElementChild.checked) {
        allStages[i].classList.add("selected")
      } else {
        allStages[i].classList.remove("selected")
      }
    }
  }

  function recalc_view() {
    if ($(".timeline-sidebar").length < 1) { return }

    // mobile
    if ($('#timelineContentMobile').children().length){
      $(".list-stages").css('height',$('.quick-links').position().top - $('.list-stages').position().top)
      $(".list-stages").css('padding-top',$('.timeline-header-mobile').position().top + $('.timeline-header-mobile').height())
    } else {
      var height = $('.homeowner-view').height() - $('.timeline-container').position().top
      if ($('.quick-links').is(":visible")) { height = height - $('.quick-links').height()}
      $('.timeline-container').css('height', height)
    }
  }

  // show the shortcut links
  $(document).on('click', '#timelineShortcuts', function (event) {
    // style the open/close button
    $(".shortcut-button").toggleClass("close")
    $(".shortcuts-question").toggleClass("shortcuts-grid")
    $(".shortcut-links").toggle()

    // toggle the fa icon when the button is opened/closed
    var button = document.getElementById("shortcutButton")
    if (this.classList.contains("close")) {
      button.classList.add("fa-times")
      button.classList.remove("fa-question")
      // center the icon
      button.style.paddingLeft = "1px"
    } else {
      button.classList.add("fa-question")
      button.classList.remove("fa-times")
      button.style.paddingLeft = "0"
    }

    // add the icons to the shortcut links
    $('#shortcutAreaGuide').addClass("icon fas fa-laptop-house")
    $('#shortcutFaqs').addClass("icon fa fa-question")
    $('#shortcutHowTos').addClass("icon fa fa-book")
    $('#shortcutServices').addClass("icon fas fa-shipping-fast")
  })

  // add the fa icons to the stage tiles
  document.addEventListener('turbolinks:load', function () {
    $('#iconReservation').addClass("fa fa-check")
    $('#iconExchange').addClass("fas fa-key")
    $('#iconMoving').addClass("fa fa-truck")
    $('#iconLiving').addClass("fas fa-male")

    $('#iconMobileReservation').addClass("fa fa-check")
    $('#iconMobileExchange').addClass("fas fa-key")
    $('#iconMobileMoving').addClass("fa fa-truck")
    $('#iconMobileLiving').addClass("fas fa-male")
  })

  $( window ).resize(function() {
    if ($(".timeline-sidebar").length < 1) { return }
    recalc_view()
  })

  // display timeline in mobile view
  document.addEventListener('turbolinks:load', function () {
    if ($(window).innerWidth() < 760) {
      var desktop = document.getElementById("timelineContentDesktop")
      var mobile = document.getElementById("timelineContentMobile")

      if(mobile) {
        // add the 'timeline-content' class in mobile
        mobile.classList.add("timeline-content")

        // move all child nodes of desktop to mobile
        while(desktop.hasChildNodes()) {
          mobile.appendChild(desktop.firstChild)
        }
      }
    }
  })

  document.addEventListener('turbolinks:load', function () {

    if ($(".timeline-sidebar").length < 1) { return }

    $('body.homeowner-view').attr('id', 'timeline-body');

    if ($('#activeTaskScroll').length) {
      if ($(window).innerWidth() < 760) {
        $('#timelineSidebar').animate({
          scrollTop: $('#activeTaskScroll').offset().top - 520
        }, 1000)
      } else {
        $('#timelineSidebar').animate({
          scrollTop: $('#activeTaskScroll').offset().top - 420
        }, 1000)
      }
    }

    // remove the hero for mobile view
    if ($('#timelineContentMobile').children().length) {
      $('.branded-hero').hide()
      $('.branded-body').css('min-height', $(document).height() - $('.brande-nav-background').height())
      $('.cookies-eu').hide()
    }

    // change the styling on the completed page
    if ($('#timelineComplete').length) {
      if ($(".list-stages").data("tt") == "proforma"){
        $('.list-stages').css('padding-top', 20)
      } else {
        $('.list-stages').css('padding-top', 80)
      }

      $('.timeline-content').css('border', 'none')

      // scroll to the bottom of the timeline
      $('#timelineSidebar').animate({
        scrollTop: $('li').last().offset().top - 1
      }, 1000)
    }

     recalc_view()
  })

})(document, window.jQuery)
