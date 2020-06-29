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

  // previews
  var iconTile = "#customTileIcon"
  var imgTile = "#customTileImage"
  var titlePreview = "#customTilePreview .title"
  var descPreview = "#customTilePreview .description"
  var btnPreview = "#customTilePreview .button-text"
  var iconPreview = "#customTileIcon i"


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
        hideDocSections()
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
    hideFeaturePreview()
    // show the preview of the selected feature
    if ($("#featureSelector select").val()) {
      $("#" + $("#featureSelector select").val()).show()
    }
  })

  // prevent the preview buttons from functioning
  $(document).on('click', '#tilePreview .branded-btn', function (event) {
    event.preventDefault()
  })

  // update preview on title input
  $(document).on('change keyup paste', '#custom_tile_title', function (event) {
      $('#customTilePreview .title').text($(this).val())
  })

  // update preview on description change
  $(document).on('change keyup paste', '#custom_tile_description', function (event) {
      $('#customTilePreview .description').text($(this).val())
  })

  // update preview on description change
  $(document).on('change keyup paste', '#custom_tile_button', function (event) {
      $('#customTilePreview .button-text').text($(this).val())
  })

  // image

  // change preview when image is removed
  $(document).on('click', '#customTileContent .remove-btn', function (event) {
    $(".image-preview").removeAttr("src")
    customTilePreview()
  })

  // change preview when image is added
  $(document).on('change', '#imageSelector input', function (event) {
    if ($('#custom_tile_image').prop("files").length) {
      imageTilePreview()
      $(imgTile).find("img").hide()
      $(imgTile).find(".image").addClass("placeholder")
      // hide the image preview and delete buttons, since their presence causes clarity issues and bugs
      $(".image-preview").hide()
      $(".remove-btn").hide()
    }
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
    hideFeaturePreview()
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

  function hideDocSections() {
    if ($("#documentSelector select").val()) {
      $(guideSelect).hide()
      $(fileSelect).hide()
    } else if ($("#guideSelector select").val()){
      $(docSelect).hide()
      $(fileSelect).hide()
    } else {
      $(docSelect).hide()
      $(guideSelect).hide()
    }
  }

  // previews

  function hideFeaturePreview() {
    $("#featurePartials").children().each(function () {
      $(this).hide()
    })
  }

  function featurePreview() {
    $("#featurePartials").show()
    if ($("#featureSelector select").val()) { $("#" + $("#featureSelector select").val()).show() }
  }

  function hideCustomTilePreview() {
    $(imgTile).hide()
    $(iconTile).hide()
    // reset preview
    $(titlePreview).text("")
    $(descPreview).text("")
    $(btnPreview).text("")
    $(iconPreview).removeClass("fa-file-pdf-o fa-external-link")
  }

  function customTilePreview() {
    // show the text
    $(titlePreview).text($("#custom_tile_title").val())
    $(descPreview).text($("#custom_tile_description").val())
    $(btnPreview).text($("#custom_tile_button").val())

    // show the image or icon preview
    if ($(".image-preview").attr("src")) {
      imageTilePreview()
    } else {
      iconTilePreview()
    }
  }

  function imageTilePreview() {
    $(iconTile).hide()
    $(imgTile).find("img").prop("src", $(".image-preview").attr("src"))
    $(imgTile).show()
  }

  function iconTilePreview() {
    $(imgTile).hide()
    if ($("#categorySelector select").val() == doc) {
      $(iconPreview).addClass("fa-file-pdf-o")
    } else {
      $(iconPreview).addClass("fa-external-link")
    }
    $(iconTile).show()
  }

})(document, window.jQuery)
