

$(document).ready(function(){

  var choice_selections = $('#choice_selections')
  var item_choices = JSON.parse(choice_selections.val())
  var visible_room = null

  checkFullHouse()

  var $roomSelect = $('.room_select select, change')
  var $roomItemSelect = $('.select_item select, change')
  var $roomItemChoiceSelect = $('.select_item_choice select, change')

  $roomSelect.selectmenu({
    select: function (event, ui) {
      ShowRoom(ui.item.label)
      ShowRoomItems(ui.item.label)
    }
  })

  $roomItemSelect.selectmenu({
    select: function (event, ui) {
      ShowItemChoices(ui.item.value)
    }
  })

  $roomItemChoiceSelect.selectmenu({
    select: function (event, ui) {
      if (ui.item.label != "Choose..."){
        recordSelection(ui.item.label, ui.item.value)
        selectImage()
      }
    }
  })

  $(".remove-item").click(function (e) {
      id = $(e.target).attr('id')
      room_item_id = id.split('_')[1]
      choice_id = item_choices[room_item_id]
      if ($(e.target).attr('data-archived') == 'false'){
        checkArchive($('#'+id).text(), choice_id)
      }
      $('#'+id).attr('class', 'unselected-item');
      $('#'+id).text('');
      delete item_choices[room_item_id]
      $('#choice_selections').val(JSON.stringify(item_choices))
      $('input[id=Reject]').prop('disabled', false);
      $('input[id=Approve]').prop('disabled', true);    
  });

  $('input[value=Reject]').click(function (e) { GetNotification() });

  $('input[id=Approve]').click(function (e) {
    $('form[name=choices]').append("<input name='commit' value='Approve' style='display:none'>")
    document.choices.submit()
  });

  $('form[name=choices]').submit(function() {
    if (fullHouse()){
      Confirm ()
      return false
    } else {
      return true
    }
  });

  function ShowRoom(roomName) {
    if (visible_room != null || roomName == "Choose...") {
      $('#' + visible_room).hide()
      visible_room = null
    }
    if (roomName != "Choose...") {
      $('#' + roomName).show()
      visible_room = roomName
    }
  }

  function ShowRoomItems(roomName){
    var roomItemsSelect = clearFields($('#room_items'))
    clearChoices()
    
    if (roomName != "Choose..."){
      var url = '/room_items'
      setFields(roomItemsSelect, url, 
                {choice_configuration: choice_selections.attr('data-configid'),  roomName: roomName},
                true)
    }
  }

  function ShowItemChoices(item){
    var roomChoicesSelect = clearChoices()
    if (item != ""){
      var url = '/item_choices'
      setFields(roomChoicesSelect, url, {roomItem: item}, true)
      ShowChoiceImages(item)
    }
  }


  function ShowChoiceImages(room_item){
    $.getJSON({
          url: '/item_images',
          data: {roomItem: room_item}
          }).done(function (response) {
            showImages(response)
            selectImage()
          })
  }

  function recordSelection(label, value){
    $('#'+$('#room_select').val()+'_'+$('#select_item').val()).html(label)
    $('#'+$('#room_select').val()+'_'+$('#select_item').val()).attr('class', 'selected-item');
    item_choices[$('#select_item').val()]=value
    $('#choice_selections').val(JSON.stringify(item_choices))
    checkFullHouse()
  }

  function checkFullHouse(){
    if (fullHouse()) {
      $('input[name=commit]').val(choice_selections.attr('data-fullhouselabel'))
    }
  }

  function fullHouse(){
    return parseInt(choice_selections.attr('data-fullhouse')) == itemChoicesLength()
  }

  function itemChoicesLength(){
    var count = 0;
    var i;

    for (i in item_choices) {
        if (item_choices.hasOwnProperty(i)) {
            count++;
        }
    }
    return count
  }

  function checkArchive (item, choice_id) {

    /// Note: _ in data content names are translated to camelCase automatically
    dialog_body = '<h3>Archive</h3>' +
        '<div>' + 
          '<p>Would you like to archive this choice?</p>' + 
          '<p>' + item + '</p>' +
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
          text: "No",
          class: 'btn-secondary',
          click: function () {
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
          }
        },
        {
          text: "Yes",
          class: 'btn-primary',
          id: 'btn_confirm',
          click: function () {
            $(this).dialog('close')
            $(this).dialog('destroy').remove()

            $.getJSON({
              url: '/archive_choice',
              data: { 
                choice_id: choice_id
               }
              }).done()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() 
  }

  function GetNotification () {

    /// Note: _ in data content names are translated to camelCase automatically
    dialog_body = '<h3>Reject</h3>' +
        '<div>' + 
          '<p>Please provide the buyer with a reason for declining their list of choices..</p>' + 
          '<p>Homeowners can re-select any choices, not just the rejected choices. Please do not commit to any stock orders until final choices are approved.</p>' + 
          '<textarea rows="10" id=notification />' + 
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
            notification = $('#notification').val().replace(/\r?\n/g, '<br>')
            $(this).dialog('close')
            $(this).dialog('destroy').remove()
            $('form[name=choices]').append("<textarea style='white-space:pre-wrap;display:none' name='notification'>" + notification + "</textarea>")
            $('form[name=choices]').append("<input name='commit' value='Reject' style='display:none'>")
            document.choices.submit()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() 
  }

  function Confirm () {

    /// Note: _ in data content names are translated to camelCase automatically
    dialog_body = '<h3>Confirm</h3>' +
        '<div>' + 
          '<p>' + choice_selections.attr('data-confirmmessage') + '</p>' +
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
            $('form[name=choices]').append("<input name='commit' value='" + choice_selections.attr('data-fullhouselabel') + "' style='display:none'>")
            document.choices.submit()
          }
        }]
    }).prev().find('.ui-dialog-titlebar-close').hide() // Hide the standard close button

  }

  function showImages(images){

    tab = $('#images table')
    tab.remove()
    table = "<table cellpadding='50'><tbody><tr>"

    $.each(images, function (key, value) {
      if (value.url != null) {
        // value also contains a name to display 
        table = table + "<td data-choice=" + value.id +"><img src='" + value.url + "'></td>";
      }
    })

    table = table + "</tr></tbody></table>";
    $("#images").append(table)
    $('#images table').addClass("dynamicTable");
    $("#images").show()         
  }

  function selectImage(){
    selected_choice_class = "selected-choice"
    selected_choice = $('.' + selected_choice_class)
    if (selected_choice != null){
      selected_choice.removeClass(selected_choice_class)
    }
    choice_item = $('#select_item').val()
    choice = item_choices[choice_item]
    if (choice != null){
      image_cell = $('td[data-choice='+choice+']')
      if (image_cell != null){
        image_cell.addClass(selected_choice_class)
      }
    }
  }

  function clearChoices(){
    $('#images').hide()
    return clearFields($('#room_item_choices'))
  }

});

$(window).load(function(){
  clearFields($('#room_items'))
  clearFields($('#room_item_choices'))
});
