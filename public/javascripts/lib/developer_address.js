
//  This page has to operate outside the scope of the turbolinks environment as
// it plays with labels and if it is loaded on pages other than that for which it
// is intended (i.e. developers addresses) then it can have adverse effects on the 
// latyout - e.g. it can remove labels etc unintentionally.  To this end this page
// should reside in the public/lib folder and should be explicity loaded by the
// page that requires it

$(document).ready(function(){

  var $countrySelect = $('.developer_country_id select, change')

 $countrySelect.selectmenu({
  create: function (event, ui) {
      var $selectInput = $(event.target)
      ShowAddressForCountry($selectInput.find('option:selected').text())
    },
    select: function (event, ui) {
      ShowAddressForCountry(ui.item.label)
    }
  })

  ShowAddressForCountry($('#developer_country_id').find('option:selected').text())

  function ShowAddressForCountry(country){

    if (country == 'UK') {
      // Show lines 1-4
      $('#developer_address_attributes_postal_number,'
      +   '#developer_address_attributes_building_name,'
      +   '#developer_address_attributes_road_name,'
      +   '#developer_address_attributes_county').show()
      // Remove Spanish placeholders
      $('#developer_address_attributes_city').removeAttr("placeholder");
      $('#developer_address_attributes_county').removeAttr("placeholder");
      $('#developer_address_attributes_postcode').removeAttr("placeholder");
      $('#developer_address_attributes_locality').attr('placeholder', 'Locality');
      // Show the labels
      $( "label:contains('Town / city')").show()
      $( "label:contains('County')").show()
      $( "label:contains('Postcode')").show()
    }
    else {
      // Hide lines 1-3 & 6
      $('#developer_address_attributes_postal_number,'
      + '#developer_address_attributes_building_name,'
      + '#developer_address_attributes_road_name,'
      + '#developer_address_attributes_county').hide()
      // Clear any Uk data
      $('#developer_address_attributes_postal_number,'
      + '#developer_address_attributes_building_name,'
      + '#developer_address_attributes_road_name,'
      + '#developer_address_attributes_county').val('')
      // Show the Spanish placeholders
      $('#developer_address_attributes_locality').attr('placeholder', 'Address Line 4');
      $('#developer_address_attributes_city').attr('placeholder', 'Address Line 5');
      $('#developer_address_attributes_postcode').attr('placeholder', 'Address Line 6');
      // Hide labels
      $( "label:contains('Town / city')").hide()
      $( "label:contains('County')").hide()
      $( "label:contains('Postcode')").hide()
    }
  }
})
