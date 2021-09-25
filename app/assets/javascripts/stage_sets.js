document.addEventListener('turbolinks:load', function () {

  if ($("#stage_sets ").length == 0 ) { return }

  ss.sectionRows().each(function( index ) {
    ss.initialiseSection($(this))
  })

  ss.setRowStatuses()
})

$(document).on('click', '#submit_stage_set', function (event) {
  if ($("#stage_sets ").length == 0 ) { return }
  ss.validate()
})

var ss = {

  initialiseSection: function(row){
    ss.swap(row.find("#up"))
    ss.swap(row.find("#down"))
    ss.insertSection(row.find("#above"))
    ss.insertSection(row.find("#below"))
    ss.checkDependents(row.find("#trash"))
  },

  setRowStatuses: function(){

    last = ss.sectionRows().length-1
    ss.sectionRows().each(function( index ) {
      if (index == 0 ) { $(this).find("#up").hide() } else { $(this).find("#up").show() }
      if (index == last ) { $(this).find("#down").hide() } else { $(this).find("#down").show() }
      if (ss.sectionRows().length == 1) { $(this).find("#trash").hide() } else { $(this).find("#trash").show() }
    })

  },

  swap: function(button) {
    button.click(function() {
      source = $(this).closest('tr')
      offset =  $(this)[0].id == 'up' ? -1 : 1
      destination = source.closest('table').find('tr').eq( source[0].rowIndex + offset)

      ss.swapit(source, destination, "#id")
      ss.swapit(source, destination, "#order")
      ss.swapit(source, destination, "td input")
    })
  },

  swapit: function(source, destination, selector)
  {
    value = destination.find(selector).val()
    destination.find(selector).val(source.find(selector).val())
    source.find(selector).val(value)
  },

  sectionRows: function() {
    return $(".section-list tbody tr")
  },

  insertSection: function(button){
    button.click(function() {
      source = $(this).closest('tr')
      newsection = $('tbody tr').first().clone()
      newsection.find("#id").val(null)
      newsection.find("#order").val(null)
      newsection.find("td input").val("").attr("placeholder", "New")
      if (button[0].id == 'above') { source.before(newsection) } else {source.after(newsection) }
        newsection.find("td input").focus()
      ss.initialiseSection(newsection)
      ss.setRowStatuses()
      ss.renumberSections()
    })
  },

  renumberSections: function(){
    const selectors = ["#id", "#order", "td input"]
    const properties = ["name", "id"]

    ss.sectionRows().each(function( index ) {
      row = $(this)
      selectors.forEach(function(selector, s_index){
        properties.forEach(function(property, p_index) {
          node = row.find(selector)
          node.prop(property, node.prop(property).replace(/\[\d]/g, "[" + index + "]"))
        })
      })
    })
  },


  deleteSection: function(button) {
    button.closest('tr').remove()
    ss.setRowStatuses()
    ss.renumberSections()
  },

  validate: function(){
    valid = true

    ss.sectionRows().each(function( index ) {
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

    if (valid) { ss.submit() }
  },

  submit: function(){
      $.post($(".edit_stage_set").attr("action"), $(".edit_stage_set").serialize())
  },

  checkDependents: function(button){
    button.click(function() {

      row = button.closest('tr')
      id = row.find('#id').val()

      if (id == ""){
        ss.deleteSection(button)
      } else {

        $.post({
          // Are there any tasks associated with this stage set?
          url: $(".edit_stage_set").attr("action") + '/tasks?stage=' + id,
          dataType: 'json',
          success: function (response) {

            if (response["dependents"] != 0) {
              dialog_body = '<h3>Delete Section</h3>' +
                '<div>' +
                  '<p>This section has ' + response["dependents"] + ' dependent task/s which will also be deleted.  Are you sure you want to continue?</p>' +
                '</div>'

              var $dialogContainer = $('<div>', { id: 'dialog', class: 'feedback-dialog' })
                .html(dialog_body)

              // Display the modal dialog and ask for confirm/cancel
              $(document.body).append($dialogContainer)

              $dialogContainer.dialog({
                show: 'show',
                modal: true,
                dialogClass: 'archive-dialog',
                buttons: [
                  {
                    text: "Cancel",
                    class: 'btn-secondary',
                    click: function () {
                      $(this).dialog('close')
                      $(this).dialog('destroy').remove()
                    }
                  },
                  {
                    text: "Confirm",
                    class: 'btn-primary',
                    id: 'btn_confirm',
                    click: function () {
                      $(this).dialog('close')
                      $(this).dialog('destroy').remove()
                      ss.deleteSection(button)
                    }
                  }]
              }).prev().find('.ui-dialog-titlebar-close').hide()
            } else {
              ss.deleteSection(button)
            }
          }
        })
      }
    })
  }
}


