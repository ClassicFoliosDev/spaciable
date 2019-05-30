
// Control the interaction of the drop downs and dialogs in the room_item 
// page.  

$(document).ready(function(){

  var $itemTypeSelect = $('.room_item_room_itemable_type select, change')
  var $itemCategorySelect = $('.room_item_room_itemable_id select, change')
  $('#room_item_category_item_ids-button').css("display", "none");

  if ( $('#operation').val().localeCompare("new") == 0) {
    ShowCategories ($('.room_item_room_itemable_type option:selected').text())
  }

  if ( $('#operation').val().localeCompare("edit") == 0) {
    ConvertItemSelectTochosen()
  }

 $itemTypeSelect.selectmenu({
    select: function (event, ui) {
      ShowCategories(ui.item.label)
    }
  })

 $itemCategorySelect.selectmenu({
    select: function (event, ui) {
      var categoryId = ui.item.value
      var itemType = $('.room_item_room_itemable_type option:selected').text()
      ShowCategoryItems({ categoryId: categoryId, itemType: itemType})

      sel = $('.room_item_room_itemable_id option:selected').text()
      $('#room_item_name').val(sel)
    }
  })

  function ShowCategories(itemtype){
    var categorySelect = clearFields($('.room_item_room_itemable_id'))
    var url = '/room_item_categories'

    setFields(categorySelect, url, {itemType: itemtype})
  }

  function ShowCategoryItems(itemcategoryId){
    $('#room_item_category_item_ids-button').css("display", "none");
    var categoryItemSelect = clearFields($('.room_item_category_item_ids'))
    var url = '/room_category_items'
    setFields(categoryItemSelect, url, itemcategoryId, false, ConvertItemSelectTochosen)
  }

  function ConvertItemSelectTochosen(){
    $(".chosen-select").chosen("destroy");
    var size = $('#room_item_category_item_ids option').size()
    if ($('#room_item_category_item_ids option').size() > 0) {
      $(".chosen-select").chosen({width: "100%"}); 
      $('#room_item_category_item_ids-button').css("display", "none");
    }
  }

})

$(window).load(function(){$('#room_item_category_item_ids-button').css("display", "none");})
