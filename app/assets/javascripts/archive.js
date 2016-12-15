$(document).on('click', '.archive-btn', function (event) {
  var dataIn = $(this).data();
  // Note: do not use _ in data content names, it will not work

  var dialog_container = document.createElement("div");
  dialog_container.id = "dialog";
  dialog_container.innerHTML = dataIn.text + "<h3>" + dataIn.name + "</h3>";

  $('body').append(dialog_container);

  $( "#dialog" ).dialog({
      show : "slide",
      modal: true,
      dialogClass: "archive-dialog",
      title: dataIn.title,
      buttons: [
        {
          text: dataIn.cancel,
          click: function () {
              $(this).dialog("close");
              $(this).dialog('destroy').remove();
          }
        },
        {
          // Font awesome trash icon added in SCSS
          text: dataIn.cta,
          class: "btn-delete",
          id: "btn_confirm",
          click: function () {
            $.ajax({
              url: dataIn.url,
              type: 'DELETE'
            });
          }
        }]
  }).prev().find(".ui-dialog-titlebar-close").hide(); // Hide the standard close button
});
