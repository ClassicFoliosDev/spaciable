document.addEventListener("turbolinks:load", function () {
  var $roleSelect = $('.user_role select');

  $roleSelect.selectmenu({
    create: function (event, ui) {
      var $selectInput = $(event.target);
      var role = $selectInput.find('option:selected').attr('value');
      showRoleResourcesOnly(role);
    },
    select: function (event, ui) {
      var value = ui.item.value;
      showRoleResourcesOnly(value);
    }
  });

  function showRoleResourcesOnly(role) {
    if (role === 'cf_admin') {
      $('.user_developer_id, .user_division_id, .user_development_id').hide();
    } else if ( role === 'developer_admin') {
      $('.user_developer_id').show();
      $('.user_division_id, .user_development_id').hide();
    } else if (role === 'division_admin') {
      $('.user_developer_id, .user_division_id').show();
      $('.user_development_id').hide();
    } else if (role === 'development_admin') {
      $('.user_developer_id, .user_division_id, .user_development_id').show();
    } else {
      $('.user_developer_id, .user_division_id, .user_development_id').hide();
    };
  };
});
