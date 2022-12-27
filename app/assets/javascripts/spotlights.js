document.addEventListener('turbolinks:load', function () {

  spots.rows().each(function( index ) {
    spots.initialiseRow($(this))
  })

  spots.setRowStatuses()
})

var spots = {

  initialiseRow: function(row){
    spots.swap(row.find("#up"))
    spots.swap(row.find("#down"))
  },

  setRowStatuses: function(){

    last = spots.rows().length-1
    spots.rows().each(function( index ) {
      $(this).find("#up").css("visibility", index == 0 ? "hidden" : "visible")
      $(this).find("#down").css("visibility", index == last ? "hidden" : "visible")
    })
  },

  swap: function(button) {
    // Handle the button clicks
    button.click(function() {
      source = $(this).closest('tr')
      goingup = ($(this)[0].id == 'up')
      target = "#" + (goingup ? source.prev() : source.next()).attr('id')
      // swap the rows in the DOM
      source = source.detach()
      if (goingup) {
        source.insertBefore(target)
      } else {
        source.insertAfter(target)
      }

      spots.setRowStatuses()
      spots.swapSequences(source, $(target))
    })
  },

  // Call back to have the record sequences swapped
  swapSequences: function(row1, row2)
  {
    $.post({
      url: "/swap?row1=" + row1.attr('id') + "&row2=" + row2.attr('id'),
      dataType: 'json'
    })
  },

  rows: function() {
    return $(".record-list tbody tr")
  }
}


