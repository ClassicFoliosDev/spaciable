// we can't use jquery document ready for these because they are loaded from partials

// finish category
$(document).on('click', '#categoryHelp', function (event) {
  $('.category-help').toggle()
})

// finish type
$(document).on('click', '#typeHelp', function (event) {
  $('.type-help').toggle()
})

// finish manufacturer
$(document).on('click', '#manufacturerHelp', function (event) {
  $('.manufacturer-help').toggle()
})

// unit type
$(document).on('click', '#unitTypeHelp', function (event) {
  unitTypeHelp()
})

$(document).on('mouseover', '#unitTypeHelp', function (event) {
  questionMouseOver($(this))
})

$(document).on('mouseout', '#unitTypeHelp', function (event) {
  questionMouseOut($(this))
})

// Spotlght
$(document).on('click', '#spotlightHelp', function (event) {
  spotlightHelp($(this))
})

$(document).on('mouseover', '#spotlightHelp', function (event) {
  questionMouseOver($(this))
})

$(document).on('mouseout', '#spotlightHelp', function (event) {
  questionMouseOut($(this))
})

// restricted unit type
$(document).on('click', '#restrictedHelp', function (event) {
  restrictedHelp()
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

// plots

$(document).on('click', '#plotStatusHelp', function (event) {
  plotStatusHelp()
})

$(document).on('mouseover', '#plotStatusHelp', function (event) {
  questionMouseOver($(this))
})

$(document).on('mouseout', '#plotStatusHelp', function (event) {
  questionMouseOut($(this))
})

// finish category
$(document).on('click', '#plotfiltersHelp', function (event) {
  $('.plot-filters-help').toggle()
})

$(document).on('click', '#stepHelp', function (event) {
  $('.step-help').is(":visible") ? $('.step-help').hide() : $('.step-help').show()
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

function spotlightHelp(container) {

  showHelpDialog(
    'spotlight-help',
    'Resident Spotlights',
    '<div class="dialog-image">' +
      '<img src="' + container.data('image') + '">' +
      '<p>' +
        'Spotlights appear on the resident dashboard, highlighting particular features, documents or links to your home buyers.' +
      '</p>' +
      '<p>' +
          'The Spaciable Team may have configured some Spotlights on your behalf, but we encourage you to make Spaciable your own by creating custom Spotlights that put important information or resources in front of your customers.' +
      '</p>' +
      '<p>' +
          "Up to five custom Spotlights can be created for each development; where less than 5 Spotlights are configured, seasonal Spaciable 'How Tos' will fill the remaining spots." +
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

function restrictedHelp() {
  var $restrictedContainer = $('<div>', { class: 'unit-restricted-help' })
  .html(
    '<div>' +
      '<p>' +
        'Editing this Spec Template is restricted by Classic Folios.' +
      '</p>' +
    '</div>' +
    '<div>' +
      '<p>' +
        'This is because any plots assigned to it have not had their completion information updated yet, ' +
        'and any changes made to this will not be reflected once the plot(s) have been populated at completion.' +
      '</p>' +
    '</div>'
  )

  $('body').append($restrictedContainer)

  $restrictedContainer.dialog({
    show: 'show',
    modal: true,
    width: 700,
    title: "Restricted Spec Template",

    buttons: [
      {
        text: "Back",
        class: 'btn',
        click: function () {
          $(this).dialog('destroy')
          $(".unit-restricted-help").hide()
        }
      }]
  }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
}

function plotStatusHelp() {
  var $statusHelpContainer = $('<div>', { class: 'plot-status-help' })
  .html(
    '<div>' +
      '<p>' +
        'A green circle in this column indicates that the completion information has been populated by Classic Folios.' +
      '</p>' +
    '</div>' +
    '<div>' +
      '<p>' +
        'If your package includes the ability for admins to configure finishes and appliances, then the green circle also signifies that you are able to edit that plot.' +
      '</p>' +
    '</div>' +
    '<div>' +
      '<p>' +
        'A red circle in this column indicates that the plot has expired. This means that residents will not see any new documents or notifications, ' +
        'but they do not lose access to the portal. To renew plot(s), please contact your Classic Folios Account Manager.' +
      '</p>' +
    '</div>'
  )

  $('body').append($statusHelpContainer)

  $statusHelpContainer.dialog({
    show: 'show',
    modal: true,
    width: 700,
    title: "Completion Information Added",

    buttons: [
      {
        text: "Back",
        class: 'btn',
        click: function () {
          $(this).dialog('destroy')
          $(".plot-status-help").hide()
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
