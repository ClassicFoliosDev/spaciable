document.addEventListener('turbolinks:load', function () {

  if ($("#build_sequence ").length == 0 ) { return }

  bs.sectionRows().each(function( index ) {
    bs.initialiseSection($(this))
  })

  bs.setRowStatuses()
})

$(document).on('click', '#submit_stage_set', function (event) {
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
  },

  setRowStatuses: function(){

    last = bs.sectionRows().length-1
    bs.sectionRows().each(function( index ) {
      if (index == 0 ) { $(this).find("td #up").each(function(i) { $(this).hide() })} else { $(this).find("td #up").each(function(i) { $(this).show() })}
      if (index == last ) { $(this).find("td #down").hide() } else { $(this).find("td #down").show() }
      if (bs.sectionRows().length == 1) { $(this).find("#trash").hide() } else { $(this).find("#trash").show() }
    })

  },

  // Swap the 'current' values with the row above/below
  swapCurrent: function(button) {
    button.click(function() {
      source = $(this).closest('tr')
      offset =  $(this)[0].id == 'up' ? -1 : 1
      destination = source.closest('table').find('tr').eq( source[0].rowIndex + offset)
      bs.swapContent(source, destination, ".current")
    })
  },

  // Swap this row with the row above/below
  swapStep: function(button) {
    button.click(function() {
      source = $(this).closest('tr')
      offset =  $(this)[0].id == 'up' ? -1 : 1
      destination = source.closest('table').find('tr').eq( source[0].rowIndex + offset)

      bs.swapVal(source, destination, "#id")
      bs.swapVal(source, destination, "#order")
      bs.swapVal(source, destination, "td input")
      bs.swapContent(source, destination, ".current")
      bs.swapVal(source, destination, "td.description .input textarea")
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

  sectionRows: function() {
    return $(".section-list tbody tr")
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
      bs.renumberSections()
    })
  },

  deleteStep: function(button){
    button.click(function() {
      clicked_row = $(button).closest('tr')
      replacement_row = clicked_row.next().length == 0 ? clicked_row.prev() : clicked_row.next()

      if (clicked_row.next().length == 0) {
        clicked_row.prev().find(".current").append(clicked_row.find(".current").html())
      } else {
        clicked_row.next().find(".current").prepend(clicked_row.find(".current").html())
      }

      clicked_row.remove()

      bs.setRowStatuses()
      bs.renumberSections()
    })
  },

  renumberSections: function(){
    const selectors = ["#id", "#order", "td input"]
    const properties = ["name", "id"]

    bs.sectionRows().each(function( index ) {
      row = $(this)
      selectors.forEach(function(selector, s_index){
        properties.forEach(function(property, p_index) {
          node = row.find(selector)
          node.prop(property, node.prop(property).replace(/\[\d]/g, "[" + index + "]"))
        })
      })
    })
  },

  validate: function(){
    valid = true

    bs.sectionRows().each(function( index ) {
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

  submit: function(){
      $.post($(".edit_stage_set").attr("action"), $(".edit_stage_set").serialize())
  }
}


