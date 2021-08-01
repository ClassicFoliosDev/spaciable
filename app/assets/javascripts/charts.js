jQuery.loadScript = function (url, callback) {
    jQuery.ajax({
        url: url,
        dataType: 'script',
        success: callback,
        async: true
    });
}

var charts = {
  $response: "",
  $developer: "0",
  $division: "0",
  $development: "0",
  $phase: "0",
  $competitions_height : "0",

  initialise: function() {
    $competitions_height = 0

    if ($("#charts").length == 0) { return }

    $.getScript( "https://www.gstatic.com/charts/loader.js", function( data, textStatus, jqxhr ) {

      google.charts.load('current', {'packages':['corechart'], callback: charts.refresh });

      window.addEventListener("resize", charts.render)

      $(document).on('click', '.desc', function (event) {
        $competitions_height = 500
        $(".desc").addClass('asc')
        $(".desc").removeClass('desc')
        charts.render_competitions()
      })

      $(document).on('click', '.asc', function (event) {
        $competitions_height = 0
        $(".asc").addClass('desc')
        $(".asc").removeClass('asc')
        charts.render_competitions()
      })
    })
  },

  refresh: function() {
    charts.selections()

    $.ajax({
      url: "/admin/charts/chartdata",
      type: "GET",
      data: { developer: $developer,
              division: $division,
              development: $development,
              phase: $phase },
      success: function(data) {
                 $response = data
                 charts.render();
               }

    })
  },

  selections: function() {
    $developer = $("#charts_developer_id").val() || "0"
    $division = $("#charts_division_id").val() || "0"
    $development = $("#charts_development_id").val() || "0"
    $phase = $("#charts_phase_id").val() || "0"
  },

  render: function() {
    $(".chart").each(function( index ) { $(this ).empty() })

    if($("#charts_developer_id").prop('disabled') &&
       ($("#charts_division_id").prop('disabled') || $("#charts_division_id").val() == "") &&
       ($("#charts_development_id").prop('disabled') || $("#charts_development_id").val() == "") &&
       $phase == "0" &&
       $response.primary.invited == 0 &&
       $response.primary.activated == 0 &&
       $response.primary.not_invited == 0) {
       $("#charts").hide()
       $("#no_plots").show()
    } else {
      $("#charts").show()
      $("#no_plots").hide()
      charts.render_charts()
      charts.render_competitions()
    }
  },

  render_charts: function() {
    if ($('#invite_activations').length == 0) { return }

    charts.invited()
    charts.not_invited()
    charts.overview()
  },

  render_competitions: function() {


    if ($('#competitions').length == 0 ||
        $phase != "0" || $developer == "0") {
      $("#competitions").hide()
      return
    } else {
      $("#competitions").show()
    }

    $("#left").show()
    $("#right").show()
    $("#competitions").show()

    if ($development != "0") {
      if (charts.no_development_ranking()) { $("#left").hide() }
      if (charts.no_development_division_ranking()) { $("#right").hide() }
      charts.development_ranking('left')
      charts.development_division_ranking('right')
    } else if ($division != "0") {
      if (charts.no_division_ranking()) { $("#left").hide() }
      if (charts.no_division_development_extremums()) { $("#right").hide() }
      charts.division_ranking('left')
      charts.division_development_extremums('right')
    } else if ($developer != "0") {
      if (charts.no_division_rankings()) { $("#left").hide() }
      if (charts.no_development_extremums()) { $("#right").hide() }
      charts.division_rankings('left')
      charts.development_extremums('right')
    }

    if(!($("#left").is(":visible") || $("#right").is(":visible"))) {
      $("#competitions").show()
    }

    $(".chart.barchart").each(function( index ) {
      this.style.height = 'auto'
    });
  },

  no_development_ranking: function() {
    return ($response.primary.invited == 0 || charts.populated_developments().length < 2)
  },

  development_ranking: function(container) {
    if (charts.no_development_ranking()) { return }
    charts.render_ranking(charts.populated_developments(), $development, container, 'Developer Ranking', "$development is placed $rank out of $total developments for plot activation across $developer.")
  },

  no_development_division_ranking: function() {
    var development = charts.get_by_id(charts.populated_developments(), $development)
    return (development == null || development.div_id == 0 ||
            charts.division_developments(development.div_id).length < 2)
  },

  development_division_ranking: function(container) {
    if (charts.no_development_division_ranking()) { return }

    var development = charts.get_by_id(charts.populated_developments(), $development)
    $division = development.div_id
    var developments = charts.division_developments($division)

    charts.render_ranking(developments, $development, container, 'Division Ranking', '$development is placed $rank out of $total developments for plot activation across $division.')
  },

  no_division_ranking: function(){
    return (charts.populated_divisions().length < 2)
  },

  division_ranking: function(container) {
    if (charts.no_division_ranking()) { return }
    charts.render_ranking(charts.populated_divisions(), $division, container, 'Developer Ranking', '$division is placed $rank out of $total divisions for plot activation across $developer')
  },

  no_division_rankings: function() {
    return (charts.populated_divisions().length < 2)
  },

  division_rankings: function(container) {
    if (charts.no_division_rankings()) { return }
    charts.render_ranking(charts.populated_divisions(), -1, container, 'Division Rankings', 'Your divisions ranked in order of plot activation percentage.')
  },

  render_ranking: function(rows, selected, container, title, desc) {
    rows = charts.sort(rows)
    range = charts.range(rows, selected)

    if (!charts.selected_populated(rows, selected) || !range.populated ) {
      $('#' + container).hide()
      return
    }

    var data = charts.data()

    rank = 0
    rows.forEach(function(row, index){
      if((index >= range.start) && (index <= range.end)) {
        if ( selected == row.id.toString()) { rank = index + 1 }
        data.addRow([charts.position(index),
                     row.percent,
                     ((selected == row.id.toString() || selected == -1) ? (row.name + ' ') : '') + charts.to_one_dp(row.percent) + '%',
                     (selected == row.id.toString() ? 'opacity:.3' : 'opacity:1') + ';color: #002A3A'])
      }
    })

    desc = charts.full_description(desc, rank, rows.length)

    charts.render_barchart(data, container, title, desc)
  },

  no_division_development_extremums: function() {
    return (charts.division_developments($division).length < 2)
  },

  division_development_extremums: function(container) {
    if (charts.no_division_development_extremums()) { return }
    charts.render_extremums(charts.division_developments($division), container, 'Development Performance', 'Your developments with highest and lowest plot activation percentage.')
  },

  no_development_extremums: function(){
    return (charts.populated_developments().length < 2)
  },

  development_extremums: function(container) {
    if (charts.no_development_extremums()) { return }
    charts.render_extremums(charts.populated_developments(), container, 'Development Performance', 'Your developments with highest and lowest plot activation percentage.')
  },

  render_extremums: function(rows, container, title, desc) {
    rows = charts.sort(rows)
    var data = charts.data()
    data.addRow(["Highest", rows[0].percent,
                  charts.row_tag(rows[0]),
                  'opacity:1;color:#25BC18'])

    data.addRow(["Lowest", rows[rows.length-1].percent,
                  charts.row_tag(rows[rows.length - 1]),
                  'opacity:1;color:#E20017'])

    charts.render_barchart(data, container, title, desc)
  },

  row_tag: function(row) {
    var tag = row.name
    if ($division == "0") {
      tag = tag + " (" + $response.competition[row.div_id].name + ")"
    }

    return tag + ' '+ charts.to_one_dp(row.percent) + '%'
  },

  render_barchart: function(data, container, title, desc) {
    $('#' + container).show()
    $('#' + container + ' .title span').text(title)
    $('#' + container + ' .description').text(desc)
    $('#' + container + ' .chart').height($('#invited').height())

    var options = {
      hAxis: {
        gridlines: {
          count: 0,
        },
        ticks: [0, 100],
        minValue: 0,
        maxValue: 100,
        baselineColor: 'white',
        textStyle: {
          color: 'black',
          textPosition: 'in'
        }
      },
      chartArea: {
            top: "3%",
            height: "90%",
            width: "80%"
      },
      legend: {
        position: 'none'
      }
    }

    if ($competitions_height != 0) { options['height'] = 500 }

    // Instantiate and draw our chart, passing in some options.
    var chart = new google.visualization.BarChart($("#"+container + " .chart")[0]);
    chart.draw(data, options)
  },

  // All Populated developments
  populated_developments: function() {
    var developments = []

    Object.keys($response.competition).forEach(function (division) {
      charts.division_developments(division).forEach(function(development) {
        if (development.percent > 0) { developments.push(development) }
      })
    })

    return developments
  },

  populated_divisions: function() {
    var divisions = []

    Object.keys($response.competition).forEach(function (division) {
        if (division != 0 && $response.competition[division].percent > 0) { divisions.push($response.competition[division]) }
    })

    return divisions
  },

  division_developments: function(division) {
    var developments = []

    Object.keys($response.competition[division]).forEach(function (development) {
      if (typeof($response.competition[division][development]) == 'object' &&
          $response.competition[division][development].percent > 0 ) {
        developments.push($response.competition[division][development])
      }
    })

    return developments
  },

  data: function() {
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'rank');
    data.addColumn('number', 'Percent');
    data.addColumn({type:'string', role: 'annotation'})
    data.addColumn({type:'string', role:'style'})

    return data
  },

  position: function(val) {
    val = val+1
    var ext = "th"
    if (val == 1 || (val > 20 && (val % 10 == 1))) {
      ext = "st"
    } else if (val == 2 || (val > 20 && (val % 10 == 2))) {
      ext = "nd"
    } else if (val == 3 || (val > 20 && (val % 10 == 3))) {
      ext = "rd"
    }

    return val.toString() + ext
  },

  range: function(array, id) {
    var range = { start: 0, end: array.length - 1, populated: (id == -1) }

    array.forEach(function(element, index) {
      if (element.id == id) {
        range.populated = true
        if (index == 0) {
          range.start = 0
          range.end = 2
        } else if (index == (array.length - 1)) {
          range.start = index - 2
          range.end = index
        } else {
          range.start = index - 1
          range.end = index + 1
        }
      }
    })

    return range
  },

  get_by_id: function(array, id) {
    e = null
    array.forEach(function(element, index){ if (element.id == id) { e = element } })
    return e
  },

  sort: function(array) {
    return array.sort(function(a, b){return b['percent'] - a['percent']});
  },

  invited: function() {
    charts.setNodeHeight('invited', .5)
    primary = $response['primary']
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Key');
    data.addColumn('number', 'Plots');
    data.addRows([
      ['Plots with an Invited Resident', primary['invited']],
      ['Plots Not Invited', primary['not_invited']]
    ]);

    // Set chart options
    var options = {
      title:'Plots Invited',
      chartArea: {
            height: "90%",
            width: "100%"
        },
      pieHole: 0.5,
      slices: {
        0: { visibleInLegend: true, color: '#25BC18' },
        1: { visibleInLegend: true, color: '#E20017'},
        2: { visibleInLegend: false, color: '#f2f2f2'}
      }
    };

    if ( charts.hundred([primary['invited'], primary['not_invited']])) { options['pieSliceTextStyle'] = { color: '#B1BBB3' } }

    charts.rationalise(data, options)

    // Instantiate and draw our chart, passing in some options.
    var chart = new google.visualization.PieChart(document.getElementById('invited'));
    chart.draw(data, options);
  },

  not_invited: function() {
    charts.setNodeHeight('activated', .5)
    primary = $response['primary']
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Key');
    data.addColumn('number', 'Plots');
    data.addRows([
      ['Plots with an Activated Resident', primary['activated'] ],
      ['Invited Plots Pending Activation', primary['invited'] - primary['activated'] ]
    ]);

    // Set chart options
    var options = {
      title:'Plots Activated',
      chartArea: {
            height: "90%",
            width: "100%"
        },
      pieHole: 0.5,
      slices: {
        0: { visibleInLegend: true, color: '#25BC18' },
        1: { visibleInLegend: true, color: '#FFA700'},
        2: { visibleInLegend: false, color: '#f2f2f2'}
      }
    };

    if ( charts.hundred([primary['activated'], (primary['invited'] - primary['activated'])])) { options['pieSliceTextStyle'] = { color: '#B1BBB3' } }

    charts.rationalise(data, options)

    // Instantiate and draw our chart, passing in some options.
    var chart = new google.visualization.PieChart(document.getElementById('activated'));
    chart.draw(data, options);
  },

  overview: function() {
    charts.setNodeHeight('overview', .5)
    primary = $response['primary']
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Key');
    data.addColumn('number', 'Plots');
    data.addRows([
      ['Plots with an Activated Resident', primary['activated'] ],
      ['Invited Plots Pending Activation', primary['invited'] - primary['activated'] ],
      ['Plots Not Invited ', primary['not_invited'] ]
    ]);

    // Set chart options
    var options = {
      title:'Plots Status Overview',
      chartArea: {
            height: "90%",
            width: "100%"
        },
      pieHole: 0.5,
      slices: {
        0: { visibleInLegend: true, color: '#25BC18' },
        1: { visibleInLegend: true, color: '#FFA700'},
        2: { visibleInLegend: true, color: '#E20017'},
        3: { visibleInLegend: false, color: '#f2f2f2'}
      }
    };

    if ( charts.hundred([primary['activated'], (primary['invited'] - primary['activated']), primary['not_invited']])) { options['pieSliceTextStyle'] = { color: '#B1BBB3' } }


    charts.rationalise(data, options)

    // Instantiate and draw our chart, passing in some options.
    var chart = new google.visualization.PieChart(document.getElementById('overview'));
    chart.draw(data, options);
  },

  rationalise: function(data, options) {
    total = 0
    for (row = 0; row < data.getNumberOfRows(); row++) { total += data.getValue(row, 1); }
    if (total != 0) { return }

    data.addRow(['filler', 1])
    options.sliceVisibilityThreshold =  0
    options.pieSliceText = 'none'
    options.tooltip = { trigger: 'none' }
  },

  setNodeHeight: function(container, ratio) {
    $('#' + container).height($('#' + container).width() * ratio)
  },

  full_description: function(desc, rank, total) {

    if (typeof desc != 'undefined') {
      desc = desc.replace("$division", $response.competition[$division].name);
      desc = desc.replace("$rank", charts.position(rank-1))
      desc = desc.replace("$total", total.toString())
      desc = desc.replace("$developer", $("#charts_developer_id option:selected").html())
      desc = desc.replace("$development", $("#charts_development_id option:selected").html())
    }

    return desc
  },

  // Is the array 100% populated by one value?
  hundred: function(values) {
    var populated = 0
    for (i = 0; i < values.length; i++) {
      populated = populated + (values[i] > 0 ? 1 : 0)
    }

    return populated == 1
  },

  selected_populated: function(rows, selected) {
    var populated = (selected == -1)
    rows.forEach(function(row, index) {
      if ( selected == row.id.toString()) {
        populated = true
      }
    })

    return populated
  },

  to_one_dp: function(value) {
    return value.toFixed((value % 1) == 0 ? 0 : 1).toString()
  },

  destroy_if_exists: function(selectmenu) {
    if (selectmenu.selectmenu( "instance" ) != undefined) {
      selectmenu.selectmenu("destroy")
    }
  }
}

document.addEventListener('turbolinks:load', function () {
  if ($("#charts").length == 0) { return }

  charts.initialise()

  var $developerSelect = $('.charts_developer_id select')
  var $divisionSelect = $('.charts_division_id select')
  var $developmentSelect = $('.charts_development_id select')
  var $phaseSelect = $('.charts_phase_id select')

  charts.destroy_if_exists($developerSelect)
  charts.destroy_if_exists($divisionSelect)
  charts.destroy_if_exists($developmentSelect)
  charts.destroy_if_exists($phaseSelect)

  $developerSelect.selectmenu($developerSelectmenuCallbacks())

  function $developerSelectmenuCallbacks () {
    return {
      create: function (event, ui) {
        var $selectInput = $(event.target)
        var developerId = $selectInput.val()
        $divisionSelect.selectmenu(divisionSelectmenuCallbacks(developerId))
      },
      select: function (event, ui) {
        var developerId = ui.item.value

        fetchDivisionResources({ developerId: developerId })
        fetchDevelopmentResources({ developerId: developerId })

        charts.refresh()
      }
    }
  };

  function divisionSelectmenuCallbacks (developerId) {
    return {
      create: function (event, ui) {
        var $selectInput = $(event.target)
        var divisionId = $selectInput.val()
        clearIfEmpty($selectInput)
        $developmentSelect.selectmenu(developmentSelectmenuCallbacks(developerId, divisionId))
      },
      select: function (event, ui) {
        var divisionId = ui.item.value

        if (divisionId !== '') {
          fetchDevelopmentResources({divisionId: divisionId})
        } else {
          fetchDevelopmentResources({developerId: $developerSelect.val()})
        };

        charts.refresh()
      }
    }
  };

  function developmentSelectmenuCallbacks (developerId, divisionId) {
    return {
      create: function (event, ui) {
        var $selectInput = $(event.target)
        var developmentId = $selectInput.val()
        clearIfEmpty($selectInput)
        $phaseSelect.selectmenu(phaseSelectmenuCallbacks(developerId, divisionId, developmentId))
      },
      select: function (event, ui) {
        var developmentId = ui.item.value

        if (developmentId !== '') {
          fetchPhaseResources({developmentId: developmentId})
        } else {
          clearFields($('.charts_phase_id'))
        };

        charts.refresh()
      }
    }
  };

  function phaseSelectmenuCallbacks (developerId, divisionId, developmentId) {
    return {
      create: function (event, ui) {
        clearIfEmpty($(event.target))
      },
      select: function (event, ui) {
        charts.refresh()
      }
    }
  };

  function clearIfEmpty(select) {
    if (select.find('option').length == 1) {
      clearFields(select.closest('div'))
    }
  }

  function fetchDeveloperResources (developerId) {
    var $developerSelect = clearFields($('.charts_developer_id'))
    var url = '/admin/developers'

    setFields($developerSelect, url, {developerId: developerId})
  };

  function fetchDivisionResources (data) {
    var divisionSelect = clearFields($('.charts_division_id'))
    var url = '/admin/divisions'

    setFields(divisionSelect, url, data)
  };

  function fetchDevelopmentResources (data) {
    var developmentSelect = clearFields($('.charts_development_id'))
    var url = '/admin/developments'

    setFields(developmentSelect, url, data)
  };

  function fetchPhaseResources (data) {
    var phaseSelect = clearFields($('.charts_phase_id'))
    var url = '/admin/phases'

    setFields(phaseSelect, url, data)
  };

})
