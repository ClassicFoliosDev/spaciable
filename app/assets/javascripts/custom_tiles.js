(function (document, $) {
  'use strict'

  // --- VARIABLES ---

  // categories
  var feature = "feature"
  var doc = "document"
  var link = "link"

  // category sections
  var featSection = "#customTileFeature"
  var docSection = "#customTileDocument"
  var linkSection = "#customTileLink"
  var contentSection = "#customTileContent"

  // document selectors
  var docSelect = "#documentSelector"
  var guideSelect = "#guideSelector"
  var fileSelect = "#fileSelector"
  var imageSelect = "#imageSelector"


  // --- EVENTS ---

  // show or hide sections on page load
  document.addEventListener('turbolinks:load', function (event) {
    if ($("#categorySelector").length) {
      var $val = $("#categorySelector select").val()

      if ($val == feature) {
        // hide sections
        $(docSection).hide()
        $(linkSection).hide()
        $(contentSection).hide()
        featurePreview()  // show preview
      } else if ($val == doc) {
        // hide sections
        $(featSection).hide()
        $(linkSection).hide()
        customTilePreview()  // show preview
      } else if ($val == link) {
        // hide sections
        $(featSection).hide()
        $(docSection).hide()
        customTilePreview()  // show preview
      }
    }
  })

  // show or hide category sections when the category is changed
  $(document).on('click', '#custom_tile_category-menu', function (event) {
    var $val = $("#categorySelector select").val()

    if ($val == feature) {
      // hide sections
      $(docSection).hide()
      $(linkSection).hide()
      $(contentSection).hide()
      // reset input
      resetDoc()
      resetLink()
      $(featSection).show()  // show section
      featurePreview()  // show preview
    } else if ($val == doc) {
      // hide sections
      $(featSection).hide()
      $(linkSection).hide()
      // reset input
      resetFeature()
      resetLink()
      // show sections
      $(docSection).show()
      $(contentSection).show()
      customTilePreview() // show preview
    } else if ($val == link) {
      // hide sections
      $(featSection).hide()
      $(docSection).hide()
      // reset input
      resetFeature()
      resetDoc()
      // show sections
      $(linkSection).show()
      $(contentSection).show()
      customTilePreview() // show preview
    }
  })

  // show or hide document sections when a file is selected
  $(document).on('change', '#customTileDocument input', function (event) {
    if ($('#fileSelector input')[0].files.length < 1) {
      $(docSelect).show()
      $(guideSelect).show()
    } else {
      // hide sections
      $(docSelect).hide()
      $(guideSelect).hide()
      // reset input
      resetDocSelect()
      resetDocGuide()
    }
  })

  // show or hide document sections when a guide is selected
  $(document).on('click', '#custom_tile_guide-menu', function (event) {
    if ($("#guideSelector select").val()) {
      // hide sections
      $(docSelect).hide()
      $(fileSelect).hide()
      // reset input
      resetDocSelect()
      resetDocUpload()
    } else {
      $(docSelect).show()
      $(fileSelect).show()
    }
  })

  // show or hide document selections when a document is selected
  $(document).on('click', '#custom_tile_document_id-menu', function (event) {
    if ($("#documentSelector select").val()) {
      // hide sections
      $(guideSelect).hide()
      $(fileSelect).hide()
      // reset input
      resetDocGuide()
      resetDocUpload()
    } else {
      $(guideSelect).show()
      $(fileSelect).show()
    }
  })

  // previews

  // show preview of feature tile when feature option is changed
  $(document).on('click', '#custom_tile_feature-menu', function (event) {
    // we don't know which feature was previously selected, so hide all
    hideFeaturePreviews()
    // show the preview of the selected feature
    if ($("#featureSelector select").val()) {
      $("#" + $("#featureSelector select").val()).show()
    }
  })

  // prevent the preview buttons from functioning
  $(document).on('click', '#featurePartials .branded-btn', function (event) {
    event.preventDefault()
  })

  // update the preview on title change
  $(document).on('keyup', '#customTileContent', function (event) {
    $('#custom_tile_title').keyup(function () {
      $('#customTilePreview .title').text($(this).val())
    })

  // update the preview on description change
    $('#custom_tile_description').keyup(function () {
      $('#customTilePreview .description').text($(this).val())
    })

    $('#custom_tile_button').keyup(function () {
      $('#customTilePreview .button-text').text($(this).val())
    })
  })


  // --- FUNCTIONS ---

  // category resets

  function resetFeature() {
    var $featSelect = $("#featureSelector")
    // reset input
    $featSelect.find("select").val(null)
    $featSelect.find("select")[0].selectedIndex = 0
    $featSelect.find(".ui-selectmenu-text")[0].innerHTML = "&nbsp;"
    // reset preview
    $("#featurePartials").hide()
    hideFeaturePreviews()
  }

  function resetDoc() {
    // reset input
    resetDocUpload()
    resetDocSelect()
    resetDocGuide()
    resetContent()
    hideCustomTilePreview()
  }

  function resetLink() {
    // reset input
    $(linkSection).find("input").val(null)
    resetContent()
    hideCustomTilePreview()
  }

  function resetContent() {
    $(contentSection).find("input").val(null)
    $(imageSelect).find("input").val(null)
  }

  // document resets

  function resetDocSelect() {
    $(docSelect).find("select")[0].selectedIndex = 0
    $(docSelect).find(".ui-selectmenu-text")[0].innerHTML = "&nbsp;"
  }

  function resetDocGuide() {
    $(guideSelect).find("select")[0].selectedIndex = 0
    $(guideSelect).find(".ui-selectmenu-text")[0].innerHTML = "&nbsp;"
  }

  function resetDocUpload() {
    $(fileSelect).find("input").val(null)
  }

  // previews

  function hideFeaturePreviews() {
    $("#featurePartials").children().each(function () {
      $(this).hide()
    })
  }

  function featurePreview() {
    $("#featurePartials").show()
    if ($("#featureSelector select").val()) { $("#" + $("#featureSelector select").val()).show() }
  }

  function hideCustomTilePreview() {
    $("#customTileImage").hide()
    $("#customTileIcon").hide()
    // reset preview
    $('#customTilePreview .title').text("")
    $('#customTilePreview .description').text("")
    $('#customTilePreview .button-text').text("")
    $("#customTileIcon i").removeClass("fa-file-pdf-o fa-external-link")
  }

  function customTilePreview() {
    // show the text
    $('#customTilePreview .title').text($("#custom_tile_title").val())
    $('#customTilePreview .description').text($("#custom_tile_description").val())
    $('#customTilePreview .button-text').text($("#custom_tile_button").val())

    // show the image or icon
    if ($(".image-preview").attr("src")) {
      $("#customTileImage").show()
      $("#customTileImage img").prop("src", $(".image-preview").attr("src"))
    } else {
      var $val = $("#categorySelector select").val()
      if ($val == doc) {
        $("#customTileIcon i").addClass("fa-file-pdf-o")
      } else {
        $("#customTileIcon i").addClass("fa-external-link")
      }
      $("#customTileIcon").show()
    }
  }

})(document, window.jQuery)