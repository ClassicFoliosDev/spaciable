document.addEventListener('turbolinks:load', function () {

  if ($(".section-list ").length == 0 ) { return }

  sectionRows().each(function( index ) {
    initialiseSection($(this))
  })

  setRowStatuses()
})

function initialiseSection(row){
  swap(row.find("#up"))
  swap(row.find("#down"))
  insertSection(row.find("#above"))
  insertSection(row.find("#below"))
  deleteSection(row.find("#trash"))
}

function setRowStatuses(){

  last = sectionRows().length-1
  sectionRows().each(function( index ) {
    if (index == 0 ) { $(this).find("#up").hide() } else { $(this).find("#up").show() }
    if (index == last ) { $(this).find("#down").hide() } else { $(this).find("#down").show() }
  })

}

function swap(button) {
  button.click(function() {
    source = $(this).closest('tr')
    offset =  $(this)[0].id == 'up' ? -1 : 1
    destination = source.closest('table').find('tr').eq( source[0].rowIndex + offset)

    swapit(source, destination, "#id")
    swapit(source, destination, "#order")
    swapit(source, destination, "td input")
  })
}

function swapit(source, destination, selector)
{
  value = destination.find(selector).val()
  destination.find(selector).val(source.find(selector).val())
  source.find(selector).val(value)
}

function sectionRows() {
  return $(".section-list tbody tr")
}

function insertSection(button){
  button.click(function() {
    source = $(this).closest('tr')
    newsection = $('tbody tr').first().clone()
    newsection.find("#id").val(null)
    newsection.find("#order").val(null)
    newsection.find("td input").val("")
    if (button[0].id == 'above') { source.before(newsection) } else {source.after(newsection) }
    initialiseSection(newsection)
    setRowStatuses()
    renumberSections()
  })
}

function renumberSections(){
  const selectors = ["#id", "#order", "td input"]
  const properties = ["name", "id"]

  sectionRows().each(function( index ) {
    row = $(this)
    selectors.forEach(function(selector, s_index){
      properties.forEach(function(property, p_index) {
        node = row.find(selector)
        node.prop(property, node.prop(property).replace(/\[\d]/g, "[" + index + "]"))
      })
    })
  })
}

function deleteSection(button){
  button.click(function() {
    $(this).closest('tr').remove()
    setRowStatuses()
    renumberSections()
  })
}

