document.addEventListener('turbolinks:load', function () {

  if ($("#build_sequence ").length == 0 ) { return }

  bs.steps().each(function( index ) {
    bs.initialiseSection($(this))
  })

  bs.setRowStatuses()
})

$(document).on('click', '#submit_stage_set', function (event) {
  if ($("#build_sequence ").length == 0 ) { return }
  bs.validate()
})

var bs = {

  initialiseSection: function(row){
    bs.swapCurrent(row.find(".step-map-actions #up"))
    bs.swapCurrent(row.find(".step-map-actions #down"))
    bs.swapStep(row.find(".step-actions #up"))
    bs.swapStep(row.find(".step-actions #down"))
    bs.insertStep(row.find("#above"))
    bs.insertStep(row.find("#below"))
    bs.deleteStep(row.find("#trash"))

    $("#build_sequence input,textarea").each(function(index) {
      $(this).on('input', function() {
        bs.dirty()
      })
    })
  },

  setRowStatuses: function(){

    last = bs.steps().length-1
    bs.steps().each(function( index ) {
      if (index == 0 ) { $(this).find("td #up").each(function(i) { $(this).hide() })} else { $(this).find("td #up").each(function(i) { $(this).show() })}
      if (index == last ) { $(this).find("td #down").hide() } else { $(this).find("td #down").show() }
      if (bs.steps().length == 1) { $(this).find("#trash").hide() } else { $(this).find("#trash").show() }
    })

  },

  // Swap the 'current' values with the row above/below
  swapCurrent: function(button) {
    button.click(function() {
      source = $(this).closest('tr')
      offset =  $(this)[0].id == 'up' ? -1 : 1
      destination = source.closest('table').find('tr').eq( source[0].rowIndex + offset)
      bs.swapContent(source, destination, ".current")
      bs.swapVal(source, destination, "#current_ids")
      bs.dirty()
    })
  },

  // Swap this row with the row above/below
  swapStep: function(button) {
    button.click(function() {
      source = $(this).closest('tr')

      if ($(this)[0].id == 'up') {
        source.prev().before(source)
      } else {
        source.next().after(source)
      }

      bs.setRowStatuses()
      bs.renumber()
      bs.dirty()
    })
  },

  swapContent: function(source, destination, selector)
  {
    content = destination.find(selector).html()
    placeholder = destination.find(selector).attr("placeholder")
    destination.find(selector).html(source.find(selector).html())
    destination.find(selector).attr("placeholder", source.find(selector).attr("placeholder"))
    source.find(selector).html(content)
    source.find(selector).attr("placeholder", placeholder)
  },

  swapVal: function(source, destination, selector)
  {
    value = destination.find(selector).val()
    placeholder = destination.find(selector).attr("placeholder")
    destination.find(selector).val(source.find(selector).val())
    destination.find(selector).attr("placeholder", source.find(selector).attr("placeholder"))
    source.find(selector).val(value)
    source.find(selector).attr("placeholder", placeholder)
  },

  // visible steps
  steps: function() {
    return $(".section-list tbody tr:visible")
  },

  // Insert a new step above/below the current
  insertStep: function(button){
    button.click(function() {
      source = $(this).closest('tr')
      newstep = $('tbody tr').first().clone()
      newstep.find("#id").val(null)
      newstep.find("#order").val(null)
      newstep.find("td input").val("").attr("placeholder", "New")
      newstep.find("td textarea").val("").attr("placeholder", "New")
      newstep.find(".current").text("")
      if (button[0].id == 'above') { source.before(newstep) } else {source.after(newstep) }
        newstep.find("td input").focus()
      bs.initialiseSection(newstep)
      bs.setRowStatuses()
      bs.renumber()
      bs.dirty()
    })
  },

  deleteStep: function(button){
    button.click(function() {
      clicked_row = $(button).closest('tr')
      is_last = (clicked_row.next().length == 0 || clicked_row.next().is(":hidden"))

      replacement_row = is_last ? clicked_row.prev() : clicked_row.next()
      current = replacement_row.find(".current")
      current_ids = replacement_row.find("#current_ids")

      if ( is_last ) {
        current.append(clicked_row.find(".current").html())
        current_ids.val(current_ids.val() + clicked_row.find("#current_ids").val())
      } else {
        current.prepend(clicked_row.find(".current").html())
        current_ids.val(clicked_row.find("#current_ids").val() + current_ids.val())
      }

      bs.markDeleted(clicked_row, is_last)
      bs.setRowStatuses()
      bs.renumber()
      bs.dirty()
    })
  },

  // Deleted rows have to be hidden, marked and put at the end so as the
  // server deletes them from the database
  markDeleted: function(row, is_last) {
    row.hide()
    row.find("input[deletefield='true']").val(true)
    if (!is_last) { $("tr").last().after(row) }
  },

  // Go through and renumber all the sections and the 'order' attributes
  renumber: function(){
    selectors = ["input", "textarea"]
    $(".section-list tbody tr").each(function( index ) {
      row = $(this)
      selectors.forEach(function(selector, _){
        row.find(selector).each(function(_) {
          $(this).prop("name", $(this).prop("name").replace(/\[\d+]/g, "[" + index + "]"))
          $(this).prop("id", $(this).prop("id").replace(/_\d+_/g, "_" + index + "_"))
        })
      })
    })

    order = 1
    $("input#order").each(function(index) { $(this).val(order); order++ })
  },

  validate: function(){
    valid = true

    bs.steps().each(function( index ) {
      title = $(this).find("td input")
      if (title.val() != "") {
        title.removeClass('field_with_errors')
        $(this).find("#title_error").remove()
      } else {
        valid = false
        if (!title.hasClass('field_with_errors')) {
          title.addClass('field_with_errors')
          title.after( "<span id='title_error' class='error'>is required, and must not be blank.</span>")
        }
      }
    })

    if (valid) { bs.submit() }
  },

  dirty: function() {
    $("#dirty").val(true)
  },

  submit: function(){
      $.post($(".edit_stage_set").attr("action"), $(".edit_stage_set").serialize())
  }
}


