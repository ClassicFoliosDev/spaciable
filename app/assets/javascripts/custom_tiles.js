(function (document, $) {
  'use strict'

  // --- VARIABLES ---

  // categories
  var feature = "feature"
  var doc = "document"
  var link = "link"
  var proforma = "content_proforma"

  // category sections
  var featSection = "#customTileFeature"
  var docSection = "#customTileDocument"
  var linkSection = "#customTileLink"
  var contentSection = "#customTileContent"
  var proformaSection = "#customTileContentProforma"


  // document selectors
  var docSelect = "#documentSelector"
  var guideSelect = "#guideSelector"
  var fileSelect = "#fileSelector"
  var imageSelect = "#imageSelector"
  var proformaSelect = "#proformaSelector"

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

    if ($("#categorySelector").length == 0) { return }

    set_selections(false)
    check_full_image()

    $("#custom_tile_category").selectmenu({
      select: function (event, ui) {
        set_selections(true)
      }
    })

    // show or hide category sections when the category is changed
    // $(document).on('change', '#custom_tile_category', function (event) {
    //  set_selections()
    // })

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

    // previews

    $("#custom_tile_guide").selectmenu({
      select: function (event, ui) {
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
      }
    })

    $("#custom_tile_document_id").selectmenu({
      select: function (event, ui) {
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
      }
    })

    $("#custom_tile_feature").selectmenu({
      select: function (event, ui) {
        // we don't know which feature was previously selected, so hide all
        hideFeaturePreview()
        // show the preview of the selected feature
        if ($("#featureSelector select").val()) {
          $("#" + $("#featureSelector select").val()).show()
        }
      }
    })

    $("#custom_tile_tileable_id").selectmenu({
      select: function (event, ui) {
        if ($(this).val() == ""){
          $("#custom_tile_tileable_type").val("")
        } else {
          $("#custom_tile_tileable_type").val("Timeline")
          if ($("#custom_tile_title").val() == "") {
            $("#custom_tile_title").val($(this)[0].options[$(this)[0].selectedIndex].text)
          }
        }
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
      check_full_image()
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
      check_full_image()
    })

    // change preview when image is added
    $(document).on('hover', '.tile-full-image', function (event) {
      if ($('#custom_tile_image').prop("files").length) {
        imageTilePreview()
        $(imgTile).find("img").hide()
        $(imgTile).find(".image").addClass("placeholder")
        // hide the image preview and delete buttons, since their presence causes clarity issues and bugs
        $(".image-preview").hide()
        $(".remove-btn").hide()
      }
      check_full_image()
    })

  })

  // --- FUNCTIONS ---

  function set_selections(reset){
    var $val = $("#categorySelector select").val()

    if ($val == feature) {
      // hide sections
      $(docSection).hide()
      $(linkSection).hide()
      $(contentSection).hide()
      $(proformaSection).hide()
      $(featSection).show()  // show section
      if (reset) {
        // reset input
        resetDoc()
        resetLink()
        resetProforma()
      }
      featurePreview()  // show preview
    } else if ($val == proforma) {
      // hide sections
      $(featSection).hide()
      $(docSection).hide()
      $(linkSection).hide()
      $(proformaSection).show()  // show section
      if (reset) {
        // reset input
        resetFeature()
        resetDoc()
        resetLink()
      }
      $(contentSection).show()
      customTilePreview()
    } else if ($val == doc) {
      // hide sections
      $(featSection).hide()
      $(linkSection).hide()
      $(proformaSection).hide()
      $(docSection).show()
      if (reset) {
        // reset input
        resetFeature()
        resetLink()
        resetProforma()
      }
      $(contentSection).show()
      customTilePreview() // show preview
    } else if ($val == link) {
      // hide sections
      $(featSection).hide()
      $(docSection).hide()
      $(proformaSection).hide()
      $(linkSection).show()
      if (reset) {
        // reset input
        resetFeature()
        resetDoc()
        resetProforma()
      }
      $(contentSection).show()
      customTilePreview() // show preview
    }
  }

  // category resets

  function resetFeature() {
    var $featSelect = $("#featureSelector")
    // reset input
    $featSelect.find("select").val(null)
    $featSelect.find("select")[0].selectedIndex = 0
    if (typeof($featSelect.find(".ui-selectmenu-text")[0]) != "undefined") {
      $featSelect.find(".ui-selectmenu-text")[0].innerHTML = "&nbsp;"
    }
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

  function resetProforma() {
    $(proformaSelect).find("select").val(null)
    $(proformaSelect).find("select")[0].selectedIndex = 0
    if (typeof($(proformaSelect).find(".ui-selectmenu-text")[0]) != "undefined") {
      $(proformaSelect).find(".ui-selectmenu-text")[0].innerHTML = "&nbsp;"
    }
    $("#custom_tile_tileable_type").val("")
    resetContent()
    hideCustomTilePreview()
  }

  // document resets

  function resetDocSelect() {
    $(docSelect).find("select")[0].selectedIndex = 0
    if (typeof($(docSelect).find(".ui-selectmenu-text")[0]) != "undefined") {
      $(docSelect).find(".ui-selectmenu-text")[0].innerHTML = "&nbsp;"
    }
  }

  function resetDocGuide() {
    $(guideSelect).find("select")[0].selectedIndex = 0
    if (typeof($(guideSelect).find(".ui-selectmenu-text")[0]) != "undefined") {
      $(guideSelect).find(".ui-selectmenu-text")[0].innerHTML = "&nbsp;"
    }
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

  function check_full_image() {
    if ($(".image-preview").is(":visible") ||
        $('#custom_tile_image').prop("files").length) {
      $("#full_image").show()
    } else {
      $("#full_image").hide()
      $("#custom_tile_full_image").prop("checked", false)
    }
  }

})(document, window.jQuery)
