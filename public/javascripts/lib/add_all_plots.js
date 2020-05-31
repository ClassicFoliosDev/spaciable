
//  This page has to operate outside the scope of the turbolinks environment as
// it plays with labels and if it is loaded on pages other than that for which it
// is intended (i.e. developers addresses) then it can have adverse effects on the
// latyout - e.g. it can remove labels etc unintentionally.  To this end this page
// should reside in the public/lib folder and should be explicity loaded by the
// page that requires it

$(document).ready(function(){

  // Add click listener for the 'All Plots' button
  document.getElementById("add_plots").addEventListener("click", addAllPlots);

  // get the phase
  function getPhase(){
    return $('#phase_id')[0].value
  }

  // Just ask the controller for all plots for the phase, then
  // put them in the mixed_list area
  function addAllPlots() {

    // Remove any alerts and notices
    $( ".alert" ).remove();
    $( ".notice" ).remove();

    $.getJSON({
    url: '/phases/' + getPhase() + '/callback',
    data: { req: "all_plots" }
    }).done(function (plots) {
      $("textarea[list='selected_plots']").val(plots.plots).change()
    })

  }
})
