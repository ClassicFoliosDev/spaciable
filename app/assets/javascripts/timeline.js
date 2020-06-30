/* global $ */
var $body = $('body')
var $num_features = 0

$(document).on('click', '#timeline-submit-btn', function (event) {

  var $form = $("#timeline_task")

  // set the reponse according to the data content of the button
  response = event.currentTarget.getAttribute('data-response')
  $("[name='response']").val(response)

  // if the response is negative
  if (response == 'negative') {
    // reveal the answer
    $('#question').hide()
    $('#answer').show()

    // change the answer element to correct display type if on mobile
    if ($(window).innerWidth() < 1025) {
      var answer = document.getElementById("answer")
      answer.style.display = "table-cell"
    }

    // record the negative response
    $.post({
      url: $form.attr('action'),
      data: $form.serialize(),
      dataType: 'json'
    }).done(function (results) {
      // Change the format for the current timeline entry to No
    }).fail(function (response) {
      flash("Failed to record response", 'alert')
    })
  } else {
    $form.submit(); // Form submission
  }

})

// show/hide answer on admin preview (timeline task show page)
$(document).on('click', '#viewAnswer', function (event) {
  $('#answer').show()
  $('#question').hide()
})

document.addEventListener('turbolinks:load', function () {
  // show page - sidebar auto scroll to active task
  // if the element does not exist then subsequent code will not run, so check it exists using length property
  if ($('#activeTaskScroll').length) {
    $('#timelineAdminSidebar').animate({
      scrollTop: $('#activeTaskScroll').offset().top - 420
    }, 1000)
  }

  // task form - add disabled class to disabled stage radio buttons
  var stageRadio = $('#stageRadio').find("input[disabled='disabled']")
  stageRadio.parents("label").addClass("disabled")
})

// task form - show the action fields on clicking add action button
$(document).on('click', '#addActionBtn', function (event) {
  $(this).hide()
  $('#actionInput').show()
  // the _destroy attribute marks a nested record for destruction
  $('#task_action_attributes__destroy').val(false)
})

// task form - hide the action fields on clicking delete action button
$(document).on('click', '#deleteActionBtn', function (event) {
  $('#actionInput').hide()
  $('#addActionBtn').show()
  // the _destroy attribute marks a nested record for destruction
  $('#task_action_attributes__destroy').val(true)
})

// task form - show the feature fields on clicking add feature button
$(document).on('click', '#addFeatureBtn', function (event) {

  if ($num_features == 1 && $('#featureInput').is(":hidden")) {
    $('#featureInput').show()
    // the _destroy attribute marks a nested record for destruction
    $('#featureInput').find("input[deletefield='true']").val(false)
  }
  else{
    addNewFeature()
  }

})

// task form - hide the feature fields on clicking delete feature button
$(document).on('click', '#deleteFeatureBtn', function (event) {
  feature = $(this).closest('#featureInput')
  feature.hide()
  feature.find("input[deletefield='true']").val(true)
})

// Set the visibility of the Add/Remove Feature/Action buttons
// based on content
$( document ).on('turbolinks:load', function() {

  $num_features = $('#featureInput').length
  $('#featureInput').each(function( index ) {
    featuretext = ""
    $(this).find("input").each(function( index ) {
      if($(this).is(":visible")) {
        featuretext += $(this).val()
      }
    })
    if (featuretext.length == 0){
      $(this).hide()
    }
  })

  if ($('#actionInput').length) {
    actiontext = $('#task_action_attributes_title').val() +
                 $('#task_action_attributes_link').val()

    actiontext.length ? $('#addActionBtn').hide() : $('#actionInput').hide()
  }

})

// Add a new feature into the DOM. Make a copy of the html for the
// first feature on the page.  Features are streamed as
// arrays e.g. name=task[features_attributes][0][description] and
// id = task_features_attributes_0_description.  This function
// clones the first feature and resets all the indices then clears
// out the text.  Finally it prepends itself itself before the addFeatureBtn
function addNewFeature(){
  newfeature = $('#featureInput').first().clone()
  newfeature.find("input").each(function( index ) { initialse_feature($(this)) })
  newfeature.find("textarea").each(function( index ) { initialse_feature($(this)) })
  $('#addFeatureBtn').before(newfeature)
  $num_features += 1
}

function initialse_feature(feature){
  feature.prop('name', feature.prop('name').replace(/0/g, $num_features))
  feature.prop('id', feature.prop('id').replace(/0/g, $num_features))
  feature.val("")
}

