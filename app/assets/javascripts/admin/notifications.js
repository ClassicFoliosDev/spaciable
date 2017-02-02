document.addEventListener("turbolinks:load", function () {
  (function () {
    var $developerSelect = $('.notification_developer_id select');
    var $divisionSelect = $('.notification_division_id select');
    var $developmentSelect = $('.notification_development_id select');
    var $phaseSelect = $('.notification_phase_id select');

    if ($developerSelect.length > 0) {
      $developerSelect.selectmenu(developerSelectmenuCallbacks());
    }

    function developerSelectmenuCallbacks() {
      return {
        create: function (event, ui) {
          var $selectInput = $(event.target);
          var developerId = $selectInput.val();

          if (developerId) {
            fetchDeveloperResources({ developerId: developerId });
            $divisionSelect.selectmenu(divisionSelectmenuCallbacks(developerId));
          } else {
            fetchDeveloperResources();
            $divisionSelect.selectmenu(divisionSelectmenuCallbacks());
          };
         },
        select: function (event, ui) {
          var developerId = ui.item.value;

          if (developerId !== "") {
            fetchDivisionResources({ developerId: developerId });
            fetchDevelopmentResources({ developerId: developerId });
            fetchPhaseResources({ developerId: developerId });
          } else {
            fetchDivisionResources();
            fetchDevelopmentResources();
            fetchPhaseResources();
          }
        }
      }
    };

    function divisionSelectmenuCallbacks(developerId) {
      return {
        create: function (event, ui) {
          var $selectInput = $(event.target);
          var divisionId = $selectInput.val();

          if (divisionId !== "") {
            fetchDivisionResources({ developerId: developerId, divisionId: divisionId});
            $developmentSelect.selectmenu(developmentSelectmenuCallbacks(developerId, divisionId));
            $phaseSelect.selectmenu(phaseSelectmenuCallbacks(developerId, divisionId));

          } else if (divisionId === ""){
            fetchDivisionResources({ developerId: developerId });
            $developmentSelect.selectmenu(developmentSelectmenuCallbacks(developerId));
            $phaseSelect.selectmenu(phaseSelectmenuCallbacks(developerId));
          };
        },
        select: function (event, ui) {
          var divisionId = ui.item.value;

            if (divisionId) {
            fetchDevelopmentResources({ divisionId: divisionId });
            fetchPhaseResources({ divisionId: divisionId });
          } else {
            fetchDevelopmentResources({ developerId: $developerSelect.val() });
            fetchPhaseResources({ developerId: $developerSelect.val() });
          };
         }
      };
    };

    function developmentSelectmenuCallbacks(developerId, divisionId) {
       return {
         create: function (event, ui) {
           var $selectInput = $(event.target);
           var developmentId = $selectInput.val();

             if (developmentId !== "") {
             fetchDevelopmentResources({
               developerId: developerId,
               divisionId: divisionId,
               developmentId: developmentId
             });
           } else if (divisionId) {
             fetchDevelopmentResources({
               developerId: developerId,
               divisionId: divisionId
             });
           } else {
             fetchDevelopmentResources({
               developerId: developerId
             });
           };
         },
         select: function (event, ui) {
           var developmentId = ui.item.value;

           if (developmentId !== "") {
             fetchPhaseResources({ developmentId: developmentId });
           };
         }
      };
    };

    function phaseSelectmenuCallbacks(developerId, divisionId, developmentId) {
      return {
        create: function (event, ui) {
          var $selectInput = $(event.target);
          var phaseId = $selectInput.val();

          if (phaseId) {
            fetchPhaseResources({
              developerId: developerId,
              divisionId: divisionId,
              developmentId: developmentId,
              phaseId: phaseId
            });
          } else if (developmentId) {
            fetchPhaseResources({
              developmentId: developmentId
            });
          } else if (divisionId) {
            fetchPhaseResources({
              divisionId: divisionId
            });
          } else {
            fetchPhaseResources({
              developerId: developerId
            });
          };
        }
      };
    };

    function fetchDeveloperResources(data) {
      var developer_select = clearFields($('.notification_developer_id'));
      var url = '/admin/developers';

      setFields(developer_select, url, data);
    };

    function fetchDivisionResources(data) {
      var division_select = clearFields($('.notification_division_id'));
      var url = '/admin/divisions';

      setFields(division_select, url, data);
    };

    function fetchDevelopmentResources(data) {
      var development_select = clearFields($('.notification_development_id'));
      var url = '/admin/developments';

      setFields(development_select, url, data);
    };

    function fetchPhaseResources(data) {
      var phaseSelect = clearFields($('.notification_phase_id'));
      var url = '/admin/phases';

      setFields(phaseSelect, url, data);
    };

  })();
});
