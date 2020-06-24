// we can't use jquery document ready for these because they are loaded from partials

// finish category
$(document).on('mouseover', '#categoryHelp', function (event) {
  $('.category-help').show()
})

$(document).on('mouseleave', '#categoryHelp', function (event) {
  $('.category-help').hide()
})

// finish type
$(document).on('mouseover', '#typeHelp', function (event) {
  $('.type-help').show()
})

$(document).on('mouseleave', '#typeHelp', function (event) {
  $('.type-help').hide()
})

// finish manufacturer
$(document).on('mouseover', '#manufacturerHelp', function (event) {
  $('.manufacturer-help').show()
})

$(document).on('mouseleave', '#manufacturerHelp', function (event) {
  $('.manufacturer-help').hide()
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

function unitTypeHelp() {
  var $unitHelpContainer = $('<div>', { class: 'unit-type-help' })
  .html(
    '<div>' +
      '<p>' +
        'The Unit Type feature allows you to create templates for your plots.' +
      '</p>' +
    '</div>' +
    '<div>' +
      '<p>' +
        'Any room, finish and appliance that you add to a Unit Type will also be shown in each plot assigned to it. ' +
        'Once a room is edited at plot level it becomes unique to that plot; any changes made to that same room in the Unit Type will not be reflected on the plot.' +
      '</p>' +
    '</div>' +
    '<div>' +
      '<p>' +
        'We recommend that you use Unit Types to populate any shared specifications, then add the remaining choices and changes at plot level.' +
      '</p>' +
    '</div>'
  )

  $('body').append($unitHelpContainer)

  $unitHelpContainer.dialog({
    show: 'show',
    modal: true,
    width: 700,
    title: "What is a Unit Type?",

    buttons: [
      {
        text: "Back",
        class: 'btn',
        click: function () {
          $(this).dialog('destroy')
        }
      }]
  }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
}

function roomBelongsHelp() {
  var $roomHelpContainer = $('<div>', { class: 'room-belongs-help' })
  .html(
    '<div>' +
      '<p>' +
        'Every room either belongs to its Unit Type or that specific plot.' +
      '</p>' +
    '</div>' +
    '<div>' +
      '<p>' +
        'If a room belongs to its Unit Type, then any change made on the Unit Type will be reflected on the plot. ' +
        'This means you can add or remove one specification and affect all relevant plots at once!' +
      '</p>' +
    '</div>' +
    '<div>' +
      '<p>' +
        'Once a room is edited at plot level, you\'ll notice the room now belongs to the plot. ' +
        'This means any changes made to the same room in the Unit Type will no longer be reflected.' +
      '</p>' +
    '</div>'
  )

  $('body').append($roomHelpContainer)

  $roomHelpContainer.dialog({
    show: 'show',
    modal: true,
    width: 700,
    title: "Rooms: Unit Type or Plot?",

    buttons: [
      {
        text: "Back",
        class: 'btn',
        click: function () {
          $(this).dialog('destroy')
        }
      }]
  }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
}

function restrictedHelp() {
  var $restrictedContainer = $('<div>', { class: 'unit-restricted-help' })
  .html(
    '<div>' +
      '<p>' +
        'Editing this Unit Type is restricted by Classic Folios.' +
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
    title: "Restricted Unit Type",

    buttons: [
      {
        text: "Back",
        class: 'btn',
        click: function () {
          $(this).dialog('destroy')
        }
      }]
  }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button
}