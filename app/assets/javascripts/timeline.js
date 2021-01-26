/* global $ */
var $body = $('body')
var $num_features = 0

$(document).on('click', '#timeline-submit-btn', function (event) {

  var $form = $("#timeline_task")

  // set the reponse according to the data content of the button
  response = event.currentTarget.getAttribute('data-response')
  $("[name='response']").val(response)
  $("[name='response_action']").val(event.currentTarget.getAttribute('action'))

  // if the response is negative
  if ($("[name='response_action']").val() == 'viewed_content_negative') {
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

  if ($num_features == 1 && $('.featureInput').is(":hidden")) {
    $('.featureInput').show()
    // the _destroy attribute marks a nested record for destruction
    $('.featureInput').find("input[deletefield='true']").val(false)
  }
  else{
    addNewFeature()
  }

})

// task form - hide the feature fields on clicking delete feature button
$(document).on('click', '#deleteFeatureBtn', function (event) {
  feature = $(this).closest('.featureInput')
  feature.hide()
  feature.find("input[deletefield='true']").val(true)
})

// Set the visibility of the Add/Remove Feature/Action buttons
// based on content
$( document ).on('turbolinks:load', function() {

  $num_features = $('.featureInput').length
  $('.featureInput').each(function( index ) {
    featuretext = ""
    $(this).find("input").each(function( index ) {
      if($(this).is(":visible")) {
        featuretext += $(this).val()
      }
    })
    $(this).find("textarea").each(function( index ) {
      if($(this).is(":visible")) {
        featuretext += $(this).text()
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

    selector = $("#actionInput select")
    selector.selectmenu({
      select: function (event, ui) {
        selectActionFeatureType($(this))
      }
    })

    hideShowFeatureLink($(this).find(".task_action_link"), selector.val() != "custom_url")
  }

  // hide all unpopulated links
  $(".featureInput").each(function(){
    selector = $(this).find("select")
    selector.selectmenu({
      select: function (event, ui) {
        selectFeatureType($(this))
      }
    })

    hideShowFeatureLink($(this).find(".task_features_link"), selector.val() != "custom_url")
  })

})

// Change the event handlers for referral buttons
$( document ).on('turbolinks:load', function() {
  $("button[data-featuretype='referrals']").each(function() {
    $(this).prop("onclick", null).off("click");
    $(this).click(function() {
      $('.refer-resident').trigger('click')
      $(".dropdown.branded-nav-background.branded-nav-text.active").trigger("click")
    })
  })
})

function selectFeatureType(selector){
  parent = selector.closest(".featureInput")
  hideShowFeatureLink(parent.find(".task_features_link"), parent.find("select").val() != "custom_url")
}

function selectActionFeatureType(selector){
  parent = selector.closest("#actionInput")
  hideShowFeatureLink(parent.find(".task_action_link"), parent.find("select").val() != "custom_url")
}

function hideShowFeatureLink(link, hide){
  // blank if changing state
  if (link.is(":hidden") != hide) {
    link.find("input").val("")
  }

  if (hide == true) { link.hide() } else { link.show() }
}

// Add a new feature into the DOM. Make a copy of the html for the
// first feature on the page.  Features are streamed as
// arrays e.g. name=task[features_attributes][0][description] and
// id = task_features_attributes_0_description.  This function
// clones the first feature and resets all the indices then clears
// out the text.  Finally it prepends itself itself before the addFeatureBtn
function addNewFeature(){
  newfeature = $('.featureInput').first().clone()
  const tags = ["input", "textarea", "label", "select" ]
  tags.forEach(function (item, index) {
    newfeature.find(item).each(function() { initialse_feature($(this)) })
  });
  $('#addFeatureBtn').before(newfeature)
  newfeature.find(".task_features_feature_type span").remove()

  select = newfeature.find("select")
  select.val(select.find("option").first().val())

  select.selectmenu({
      select: function (event, ui) {
        selectFeatureType($(this))
      }
  })
  select.val(select.find("option").first().val())
  selectFeatureType(select)

  $num_features += 1
}

function initialse_feature(feature){
  const attribs = ["aria-owns", "name", "id", "for"]
  attribs.forEach(function(attrib, index){
    var prop = feature.prop(attrib);
    if (typeof prop !== typeof undefined && prop !== false) {
      feature.prop(attrib, feature.prop(attrib).replace(/0/g, $num_features))
    }
    var attr = feature.attr(attrib);
    if (typeof attr !== typeof undefined && attr !== false) {
      feature.attr(attrib, feature.attr(attrib).replace(/0/g, $num_features))
    }
  })
  feature.val("")
}

