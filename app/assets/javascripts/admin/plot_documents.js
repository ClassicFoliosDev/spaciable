document.addEventListener("turbolinks:load", function() {
    if ($(".plot_documents").length > 0) {
        (function () {
            $(".plot_documents .plot-select select").selectmenu({
                change: function(event, ui) {
                    var $form = $(this).closest("form");

                    $.post({
                        url: $form.attr("action"),
                        data: $form.serialize(),
                        dataType: "json"
                    }).done(function (results, a, b) {
                        console.log(results)
                    }).fail(function (response, a, b) {
                        console.log(response)
                    });
                }
            })
        })();
    }
});
