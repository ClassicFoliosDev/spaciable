(function (document, $) {
  'use strict'

  // --- VARIABLES ---
  var spotlight1 = "#spotlight0"
  var spotlight2 = "#spotlight1"

  const spotlights = [{id: spotlight1,
                       index: 0 },
                      {id: spotlight2,
                       index: 1}]

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
    if ($('#spotlight_category').length == 0) { return }
    check_spotlights()

    $("#spotlight_category").selectmenu({
      select: function (event, ui) {
        check_spotlights()
      }
    })

    spotlights.forEach(function(spotlight) {
      set_selections(spotlight, false)
      check_full_image(spotlight)

      var tab = $(".tab[spotlight='spotlight" + spotlight.index +"'] span")
      tab.toggleClass('error', $(spotlight.id + ' .error').length != 0)

      $("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_category")).selectmenu({
        select: function (event, ui) {
          set_selections(spotlight, true)
        }
      })

      // show or hide category sections when the category is changed
      // $(document).on('change', '#custom_tile_category', function (event) {
      //  set_selections()
      // })

      // show or hide document sections when a file is selected
      $(document).on('change', spotlight_selector(spotlight, '#customTileDocument input'), function (event) {
        if ($(spotlight_selector(spotlight,'#fileSelector input'))[0].files.length < 1) {
          $(spotlight_selector(spotlight, docSelect)).show()
          $(spotlight_selector(spotlight, guideSelect)).show()
        } else {
          // hide sections
          $(spotlight_selector(spotlight, docSelect)).hide()
          $(spotlight_selector(spotlight, guideSelect)).hide()
          // reset input
          resetDocSelect(spotlight)
          resetDocGuide(spotlight)
        }
      })

      // previews
      $("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_guide")).selectmenu({
        select: function (event, ui) {
          if ($(spotlight_selector(spotlight, "#guideSelector select")).val()) {
            // hide sections
            $(spotlight_selector(spotlight, docSelect)).hide()
            $(spotlight_selector(spotlight, fileSelect)).hide()
            // reset input
            resetDocSelect(spotlight)
            resetDocUpload(spotlight)
          } else {
            $(spotlight_selector(spotlight, docSelect)).show()
            $(spotlight_selector(spotlight, fileSelect)).show()
          }
        }
      })

      $("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_document_id")).selectmenu({
        select: function (event, ui) {
          if ($(spotlight_selector(spotlight, "#documentSelector select")).val()) {
            // hide sections
            $(spotlight_selector(spotlight, guideSelect)).hide()
            $(spotlight_selector(spotlight, fileSelect)).hide()
            // reset input
            resetDocGuide(spotlight)
            resetDocUpload(spotlight)
          } else {
            $(spotlight_selector(spotlight, guideSelect)).show()
            $(spotlight_selector(spotlight, fileSelect)).show()
          }
        }
      })

      $("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_feature")).selectmenu({
        select: function (event, ui) {
          // we don't know which feature was previously selected, so hide all
          hideFeaturePreview(spotlight)
          // show the preview of the selected feature
          if ($(spotlight_selector(spotlight, "#featureSelector select")).val()) {
            $(spotlight_selector(spotlight, "#" + $(spotlight_selector(spotlight, "#featureSelector select")).val())).show()
          }

          check_appears()
        }
      })

      $("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_tileable_id")).selectmenu({
        select: function (event, ui) {
          if ($(this).val() == ""){
            $("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_tileable_type")).val("")
          } else {
            $("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_tileable_type")).val("Timeline")
            if ($("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_title")).val() == "") {
              $("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_title")).val($(this)[0].options[$(this)[0].selectedIndex].text)
            }
          }
        }
      })

      // prevent the preview buttons from functioning
      $(document).on('click', spotlight_selector(spotlight, '#tilePreview .branded-btn'), function (event) {
        event.preventDefault()
      })

      // update preview on title input
      $(document).on('change keyup paste', '#spotlight_custom_tiles_attributes_'.concat(spotlight.index, '_title'), function (event) {
          $(spotlight_selector(spotlight, '#customTilePreview .title')).text($(this).val())
      })

      // update preview on description change
      $(document).on('change keyup paste', '#spotlight_custom_tiles_attributes_'.concat(spotlight.index, '_description'), function (event) {
          $(spotlight_selector(spotlight, '#customTilePreview .description')).text($(this).val())
      })

      // update preview on description change
      $(document).on('change keyup paste', '#spotlight_custom_tiles_attributes_'.concat(spotlight.index, '_button'), function (event) {
          $(spotlight_selector(spotlight, '#customTilePreview .button-text')).text($(this).val())
      })

      // image

      // change preview when image is removed
      $(document).on('click', spotlight_selector(spotlight, '#customTileContent .remove-btn'), function (event) {
        $(spotlight_selector(spotlight, ".image-preview")).removeAttr("src")
        customTilePreview(spotlight)
        check_full_image(spotlight)
      })

      // change preview when image is added
      $(document).on('change', spotlight_selector(spotlight, '#imageSelector input'), function (event) {
        if ($('#spotlight_custom_tiles_attributes_'.concat(spotlight.index, '_image')).prop("files").length) {
          imageTilePreview(spotlight)
          $(spotlight_selector(spotlight, imgTile)).find("img").hide()
          $(spotlight_selector(spotlight, imgTile)).find(".image").addClass("placeholder")
          // hide the image preview and delete buttons, since their presence causes clarity issues and bugs
          $(spotlight_selector(spotlight, ".image-preview")).hide()
          $(spotlight_selector(spotlight, ".remove-btn")).hide()
        }
        check_full_image(spotlight)
      })

      $(document).on('click', '#spotlight_custom_tiles_attributes_'.concat(spotlight.index, '_render_title'), function (event) {
        customTilePreview(spotlight)
      })

      $(document).on('click', '#spotlight_custom_tiles_attributes_'.concat(spotlight.index, '_render_description'), function (event) {
        customTilePreview(spotlight)
      })

      $(document).on('click', '#spotlight_custom_tiles_attributes_'.concat(spotlight.index, '_render_description'), function (event) {
        customTilePreview(spotlight)
      })

      $(document).on('click', '#spotlight_custom_tiles_attributes_'.concat(spotlight.index, '_render_button'), function (event) {
        customTilePreview(spotlight)
      })

      $(document).on('click', '#spotlight_custom_tiles_attributes_'.concat(spotlight.index, '_full_image'), function (event) {
        customTilePreview(spotlight)
      })

      $(document).on('click', ".tab[spotlight='spotlight".concat(spotlight.index,"'] span"), function (event) {
        tab_selected(spotlight.id)
      })

      $(spotlight_selector(spotlight, '#customTileAppears input[type=radio]')).change(function(){
        $("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_appears_after_date")).prop('disabled', ($(this).val() != "emd_date" ))
      })
    })
  })


  // --- FUNCTIONS ---

  function set_selections(spotlight, reset){
    var $val = $(spotlight_selector(spotlight, "#categorySelector select")).val()

    if ($val == feature) {
      // hide sections
      $(spotlight_selector(spotlight, docSection)).hide()
      $(spotlight_selector(spotlight, linkSection)).hide()
      $(spotlight_selector(spotlight, contentSection)).hide()
      $(spotlight_selector(spotlight,proformaSection)).hide()
      $(spotlight_selector(spotlight,featSection)).show()  // show section
      if (reset) {
        // reset input
        resetDoc(spotlight)
        resetLink(spotlight)
        resetProforma(spotlight)
      }
      featurePreview(spotlight)  // show preview
    } else if ($val == proforma) {
      // hide sections
      $(spotlight_selector(spotlight, featSection)).hide()
      $(spotlight_selector(spotlight, docSection)).hide()
      $(spotlight_selector(spotlight, linkSection)).hide()
      $(spotlight_selector(spotlight, proformaSection)).show()  // show section
      if (reset) {
        // reset input
        resetFeature(spotlight)
        resetDoc(spotlight)
        resetLink(spotlight)
      }
      $(spotlight_selector(spotlight, contentSection)).show()
      customTilePreview(spotlight)
    } else if ($val == doc) {
      // hide sections
      $(spotlight_selector(spotlight, featSection)).hide()
      $(spotlight_selector(spotlight, linkSection)).hide()
      $(spotlight_selector(spotlight, proformaSection)).hide()
      $(spotlight_selector(spotlight, docSection)).show()
      if (reset) {
        // reset input
        resetFeature(spotlight)
        resetLink(spotlight)
        resetProforma(spotlight)
      }
      $(spotlight_selector(spotlight, contentSection)).show()
      customTilePreview(spotlight) // show preview
    } else if ($val == link) {
      // hide sections
      $(spotlight_selector(spotlight, featSection)).hide()
      $(spotlight_selector(spotlight, docSection)).hide()
      $(spotlight_selector(spotlight, proformaSection)).hide()
      $(spotlight_selector(spotlight, linkSection)).show()
      if (reset) {
        // reset input
        resetFeature(spotlight)
        resetDoc(spotlight)
        resetProforma(spotlight)
      }
      $(spotlight_selector(spotlight, contentSection)).show()
      customTilePreview(spotlight) // show preview
    }

    check_appears()
  }

  // category resets

  function resetFeature(spotlight) {
    var $featSelect = $(spotlight_selector(spotlight, "#featureSelector"))
    // reset input
    $featSelect.find("select").val(null)
    $featSelect.find("select")[0].selectedIndex = 0
    if (typeof($featSelect.find(".ui-selectmenu-text")[0]) != "undefined") {
      $featSelect.find(".ui-selectmenu-text")[0].innerHTML = "&nbsp;"
    }
    // reset preview
    $(spotlight_selector(spotlight, "#featurePartials")).hide()
    hideFeaturePreview(spotlight)
  }

  function resetDoc(spotlight) {
    // reset input
    resetDocUpload(spotlight)
    resetDocSelect(spotlight)
    resetDocGuide(spotlight)
    resetContent(spotlight)
    hideCustomTilePreview(spotlight)
  }

  function resetLink(spotlight) {
    // reset input
    $(spotlight_selector(spotlight, linkSection)).find("input[type=text]").val(null)
    resetContent(spotlight)
    hideCustomTilePreview(spotlight)
  }

  function resetContent(spotlight) {
    $(spotlight_selector(spotlight, contentSection)).find("input[type=text]").val(null)
    $(spotlight_selector(spotlight, imageSelect)).find("input").val(null)
  }

  function resetProforma(spotlight) {
    $(spotlight_selector(spotlight, proformaSelect)).find("select").val(null)
    $(spotlight_selector(spotlight, proformaSelect)).find("select")[0].selectedIndex = 0
    if (typeof($(spotlight_selector(spotlight, proformaSelect)).find(".ui-selectmenu-text")[0]) != "undefined") {
      $(spotlight_selector(spotlight, proformaSelect)).find(".ui-selectmenu-text")[0].innerHTML = "&nbsp;"
    }
    $("#custom_tile_tileable_type").val("")
    resetContent(spotlight)
    hideCustomTilePreview(spotlight)
  }

  // document resets

  function resetDocSelect(spotlight) {
    $(spotlight_selector(spotlight, docSelect)).find("select")[0].selectedIndex = 0
    if (typeof($(spotlight_selector(spotlight, docSelect)).find(".ui-selectmenu-text")[0]) != "undefined") {
      $(spotlight_selector(spotlight, docSelect)).find(".ui-selectmenu-text")[0].innerHTML = "&nbsp;"
    }
  }

  function resetDocGuide(spotlight) {
    $(spotlight_selector(spotlight, guideSelect)).find("select")[0].selectedIndex = 0
    if (typeof($(spotlight_selector(spotlight, guideSelect)).find(".ui-selectmenu-text")[0]) != "undefined") {
      $(spotlight_selector(spotlight, guideSelect)).find(".ui-selectmenu-text")[0].innerHTML = "&nbsp;"
    }
  }

  function resetDocUpload(spotlight) {
    $(spotlight_selector(spotlight, fileSelect)).find("input").val(null)
  }

  function hideDocSections(spotlight) {
    if ($(spotlight_selector(spotlight, "#documentSelector select")).val()) {
      $(spotlight_selector(spotlight, guideSelect)).hide()
      $(spotlight_selector(spotlight, fileSelect)).hide()
    } else if ($(spotlight_selector(spotlight,  "#guideSelector select")).val()){
      $(spotlight_selector(spotlight, docSelect)).hide()
      $(spotlight_selector(spotlight, fileSelect)).hide()
    } else {
      $(spotlight_selector(spotlight, docSelect)).hide()
      $(spotlight_selector(spotlight, guideSelect)).hide()
    }
  }

  // previews

  function hideFeaturePreview(spotlight) {
    $(spotlight_selector(spotlight, "#featurePartials")).children().each(function () {
      $(this).hide()
    })
  }

  function featurePreview(spotlight) {
    $(spotlight_selector(spotlight, "#featurePartials")).show()
    if ($(spotlight_selector(spotlight, "#featureSelector select")).val()) { $(spotlight_selector(spotlight, "#" + $(spotlight_selector(spotlight, "#featureSelector select")).val())).show() }
  }

  function hideCustomTilePreview(spotlight) {
    $(spotlight_selector(spotlight, imgTile)).hide()
    $(spotlight_selector(spotlight, iconTile)).hide()
    // reset preview
    $(spotlight_selector(spotlight, titlePreview)).text("")
    $(spotlight_selector(spotlight, descPreview)).text("")
    $(spotlight_selector(spotlight, btnPreview)).text("")
    $(spotlight_selector(spotlight, iconPreview)).removeClass("fa-file-pdf-o fa-external-link")
  }

  function customTilePreview(spotlight) {

    // full width image
    $(spotlight_selector(spotlight, "#image")).removeClass("image full-image")
    $(spotlight_selector(spotlight, "#content")).removeClass("content full-content")
    if ($("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_full_image")).prop("checked")) {
      $(spotlight_selector(spotlight, "#image")).addClass("full-image")
      $(spotlight_selector(spotlight, "#content")).addClass("full-content")
    } else {
      $(spotlight_selector(spotlight, "#image")).addClass("image")
      $(spotlight_selector(spotlight, "#content")).addClass("content")
    }

    // handle the render options
    $(spotlight_selector(spotlight, titlePreview)).toggle($("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_render_title")).prop("checked"))
    $(spotlight_selector(spotlight, descPreview)).toggle($("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_render_description")).prop("checked"))
    $(spotlight_selector(spotlight, btnPreview)).toggle($("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_render_button")).prop("checked"))

    // show the text
    $(spotlight_selector(spotlight, titlePreview)).text($("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_title")).val())
    $(spotlight_selector(spotlight, descPreview)).text($("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_description")).val())
    $(spotlight_selector(spotlight, btnPreview)).text($("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_button")).val())

    // show the image or icon preview
    if ($(spotlight_selector(spotlight, ".image-preview")).attr("src") ||
        $(spotlight_selector(spotlight, "#image")).hasClass("placeholder")) {
      imageTilePreview(spotlight)
    } else {
      iconTilePreview(spotlight)
    }
  }

  function imageTilePreview(spotlight) {
    $(spotlight_selector(spotlight, iconTile)).hide()
    $(spotlight_selector(spotlight, imgTile)).find("img").prop("src", $(spotlight_selector(spotlight, ".image-preview")).attr("src"))
    $(spotlight_selector(spotlight, imgTile)).show()
  }

  function iconTilePreview(spotlight) {
    $(spotlight_selector(spotlight, imgTile)).hide()
    if ($(spotlight_selector(spotlight, "#categorySelector select")).val() == doc) {
      $(spotlight_selector(spotlight, iconPreview)).addClass("fa-file-pdf-o")
    } else {
      $(spotlight_selector(spotlight, iconPreview)).addClass("fa-external-link")
    }
    $(spotlight_selector(spotlight, iconTile)).show()
  }

  function check_full_image(spotlight) {
    if ($(spotlight_selector(spotlight, ".image-preview")).is(":visible") ||
        $('#spotlight_custom_tiles_attributes_'.concat(spotlight.index, '_image')).prop("files").length) {
      $(spotlight_selector(spotlight, "#full_image")).show()
    } else {
      $(spotlight_selector(spotlight, "#full_image")).hide()
      $("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_full_image")).prop("checked", false)
    }
  }

  // Appears is local to spotlight[0]
  function check_appears() {
    var spotlight = spotlights[0]
    if (($("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_category")).find(":selected").val() != "feature" ||
        $("#spotlight_custom_tiles_attributes_".concat(spotlight.index, "_feature")).find(":selected").val() == "timeline") && !is_dynamic()) {
      $(spotlight_selector(spotlight, "#appears")).show()
    } else {
      $(spotlight_selector(spotlight, "#appears")).hide()
      $("#appears_always").prop('checked',true)
    }
  }

  function spotlight_selector(spotlight, selector){
    return spotlight.id.concat(" ", selector)
  }

  function is_dynamic() {
    return ($('#spotlight_category').val() == 'dynamic')
  }

  function tab_selected(spotlight_id) {
    spotlights.forEach(function(spotlight) {
      var tab = $(".tab[spotlight='spotlight" + spotlight.index +"'] span")
      tab.toggleClass('active', (spotlight.id == spotlight_id))
      $(spotlight.id).toggle(spotlight.id == spotlight_id)
    })
  }

  function check_spotlights() {
    $('.tabs').toggle(is_dynamic())
    $(spotlight1).toggle(!is_dynamic())
    $(spotlight2).toggle(is_dynamic())
    $(".meta").toggleClass('shallow', is_dynamic())
    if (is_dynamic()) { tab_selected(spotlight1)}
    $('#appears_until_emd').toggle(is_dynamic())
    $('#spotlight_custom_tiles_attributes_1__destroy').val(!is_dynamic())
    check_appears()
  }

})(document, window.jQuery)


