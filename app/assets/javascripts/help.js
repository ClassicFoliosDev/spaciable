// we can't use jquery document ready for these because they are loaded from partials

// finish category
$(document).on('click', '#categoryHelp', function (event) {
  $('.category-help').toggle()
})

// finish type
$(document).on('click', '#typeHelp', function (event) {
  $('.type-help').toggle()
})

$(document).on('click', '#whyBulkEditHelp', function (event) {
  $('.why-bulk-edit-help').toggle()
})

$(document).on('click', '#howBulkEditHelp', function (event) {
  $('.how-bulk-edit-help').toggle()
})

// finish manufacturer
$(document).on('click', '#manufacturerHelp', function (event) {
  $('.manufacturer-help').toggle()
})

$(document).on('mouseover', 'i.popup-help', function (event) {
  questionMouseOver($(this))
})

$(document).on('mouseout', 'i.popup-help', function (event) {
  questionMouseOut($(this))
})

// Contact Tag
$(document).on('click', '#contactTagHelp', function (event) {
  contactTagHelp($(this))
})

$(document).on('mouseover', '#contactTagHelp', function (event) {
  questionMouseOver($(this))
})

$(document).on('mouseout', '#contactTagHelp', function (event) {
  questionMouseOut($(this))
})

// room
$(document).on('click', '#roomBelongsHelp', function (event) {
  roomBelongsHelp()
})

$(document).on('mouseover', '#roomBelongsHelp', function (event) {
  questionMouseOver($(this))
})

$(document).on('mouseout', '#roomBelongsHelp', function (event) {
  questionMouseOut($(this))
})

// finish category
$(document).on('click', '#plotfiltersHelp', function (event) {
  $('.plot-filters-help').toggle()
})

$(document).on('click', '#stepHelp', function (event) {
  $('.step-help').toggle()
})

// FUNCTIONS

function questionMouseOver(question) {
  question.addClass('fa-question-circle')
  question.removeClass('fa-question-circle-o')
  question.css('font-size', '16px')
}

function questionMouseOut(question) {
  question.removeClass('fa-question-circle')
  question.addClass('fa-question-circle-o')
  question.css('font-size', '14px')
}

function contactTagHelp(container) {

  showHelpDialog(
    'spotlight-help',
    'Contact Tag',
    '<div class="dialog-image">' +
      '<img src="' + container.data('image') + '">' +
      '<p>' +
        'Contact tag.' +
      '</p>' +
    '</div>'
  )
}

function unitTypeHelp() {

  showHelpDialog(
    'unit-type-help',
    'What is a Spec Template?',
    '<div>' +
      '<p>' +
        'The Spec Template feature allows you to create templates for your plots.' +
      '</p>' +
    '</div>' +
    '<div>' +
      '<p>' +
        'Any room, finish and appliance that you add to a Spec Template will also be shown in each plot assigned to it. ' +
        'Once a room is edited at plot level it becomes unique to that plot; any changes made to that same room in the Spec Template will not be reflected on the plot.' +
      '</p>' +
    '</div>' +
    '<div>' +
      '<p>' +
        'We recommend that you use Spec Templates to populate any shared specifications, then add the remaining choices and changes at plot level.' +
      '</p>' +
    '</div>'
  )
}

function roomBelongsHelp() {
  var $roomHelpContainer = $('<div>', { class: 'room-belongs-help' })
  .html(
    '<div>' +
      '<p>' +
        'Every room either belongs to its Spec Template or that specific plot.' +
      '</p>' +
    '</div>' +
    '<div>' +
      '<p>' +
        'If a room belongs to its Spec Template, then any change made on the Spec Template will be reflected on the plot. ' +
        'This means you can add or remove one specification and affect all relevant plots at once!' +
      '</p>' +
    '</div>' +
    '<div>' +
      '<p>' +
        'Once a room is edited at plot level, you\'ll notice the room now belongs to the plot. ' +
        'This means any changes made to the same room in the Spec Template will no longer be reflected.' +
      '</p>' +
    '</div>'
  )

  $('body').append($roomHelpContainer)

  $roomHelpContainer.dialog({
    show: 'show',
    modal: true,
    width: 700,
    title: "Rooms: Spec Template or Plot?",

    buttons: [
      {
        text: "Back",
        class: 'btn',
        click: function () {
          $(this).dialog('destroy')
          $(".room-belongs-help").hide()
        }
      }]
  }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
}

function showHelpDialog(klass, title, body) {
  var $dialogContainer = $('<div>', { class: klass })
  .html(body)

  $('body').append($dialogContainer)

  $dialogContainer.dialog({
    show: 'show',
    modal: true,
    width: 700,
    title: title,
    buttons: [
      {
        text: "Back",
        class: 'btn',
        click: function () {
          $(this).dialog('destroy')
          $("." + klass).hide()
        }
      }]
  }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
}

$(document).on('click', '.dropdown-help', function (event) {
  $(this).closest('div').find("#dropdown-help").toggle()
})
