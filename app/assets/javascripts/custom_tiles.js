(function (document, $) {
  'use strict'

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

  // define the sections to show on page load
  document.addEventListener('turbolinks:load', function (event) {
    if ($("#categorySelector").length) {
      var $val = $("#categorySelector select").val()
      if ($val == feature) {
        $(docSection).hide()
        $(linkSection).hide()
        $(contentSection).hide()
      } else if ($val == doc) {
        $(featSection).hide()
        $(linkSection).hide()
        $(contentSection).hide()
      } else if ($val == link) {
        $(featSection).hide()
        $(docSection).hide()
        $(contentSection).hide()
      }
    }
  })

  // show or hide category sections when the category is changed
  $(document).on('click', '#custom_tile_category-menu', function (event) {
    var $val = $("#categorySelector select").val()
    if ($val == feature) {
      $(featSection).show()
      $(docSection).hide()
      resetDoc()
      $(linkSection).hide()
      resetLink()
      $(contentSection).hide()
      resetContent()
    } else if ($val == doc) {
      $(featSection).hide()
      resetFeature()
      $(docSection).show()
      $(linkSection).hide()
      resetLink()
      $(contentSection).show()
    } else if ($val == link) {
      $(featSection).hide()
      resetFeature()
      $(docSection).hide()
      resetDoc()
      $(linkSection).show()
      $(contentSection).show()
    }
  })

  // show or hide document sections when a file is selected
  $(document).on('change', '#customTileDocument input', function (event) {
    if ($('#fileSelector input')[0].files.length < 1) {
      $(docSelect).show()
      $(guideSelect).show()
    } else {
      $(docSelect).hide()
      resetDocSelect()
      $(guideSelect).hide()
      resetDocGuide()
    }
  })

  // show or hide document sections when a guide is selected
  $(document).on('click', '#custom_tile_guide-menu', function (event) {
    if ($("#guideSelector select").val()) {
      $(docSelect).hide()
      resetDocSelect()
      $(fileSelect).hide()
      resetDocUpload()
    } else {
      $(docSelect).show()
      $(fileSelect).show()
    }
  })

  // show or hide document selections when a document is selected
  $(document).on('click', '#custom_tile_document_id-menu', function (event) {
    if ($("#guideSelector select").val()) {
      $(guideSelect).hide()
      resetDocGuide()
      $(fileSelect).hide()
      resetDocUpload()
    } else {
      $(guideSelect).show()
      $(fileSelect).show()
    }
  })

  // category resets

  function resetDoc() {
    resetDocUpload()
    resetDocSelect()
    resetDocGuide()
  }

  function resetLink() {
    $(linkSection).find("input").val(null)
  }

  function resetContent() {
    $(contentSection).find("input").val(null)
  }

  function resetFeature() {
    $(featSection).find("select").val(null)
    var $featSelect = $("#featureSelector")
    $featSelect.find("select")[0].selectedIndex = 0
    $featSelect.find(".ui-selectmenu-text")[0].innerHTML = "&nbsp;"
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

})(document, window.jQuery)