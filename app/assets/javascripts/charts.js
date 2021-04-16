var charts = {
  $response: "",
  $developer: "0",
  $division: "0",
  $development: "0",
  $phase: "0",

  initialise: function() {
    if ($("#charts").length == 0) { return }

    google.charts.load('current', {'packages':['corechart'], callback: charts.refresh });
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

    charts.invited()
    charts.not_invited()
    charts.overview()

    if ($phase != "0") {
      $("#competitions").hide()
    } else if ($development != "0") {
      var rendered = charts.development_ranking('left')
      charts.development_division_ranking(rendered ? 'right' : 'left')
    } else if ($division != "0") {
      var rendered = charts.division_ranking('left')
      charts.division_development_extremums(rendered ? 'right' : 'left')
    } else if ($developer != "0") {
      var rendered = charts.division_rankings('left')
      charts.development_extremums(rendered ? 'right' : 'left')
    } else {
      $("#competitions").hide()
    }
  },

  development_ranking: function(container) {
    var developments = charts.all_developments()

    if (developments.length < 2) { return false }

    charts.render_ranking(developments, $development, container, 'Developer Ranking')

    return true
  },

  development_division_ranking: function(container) {
    var development = charts.get_by_id(charts.all_developments(), $development)
    if (development == null || development.div_id == 0 ) { return false }

    var developments = charts.division_developments(development.div_id)
    if (developments.length < 2) { return false }

    charts.render_ranking(developments, $development, container, 'Developer Division Ranking')

    return true
  },

  division_ranking: function(container) {
    var divisions = charts.all_divisions()
    if (divisions.length < 2) { return false }

    charts.render_ranking(divisions, $division, container, 'Division Ranking')

    return true
  },

  division_rankings: function(container) {
    var divisions = charts.all_divisions()
    if (divisions.length < 2) { return false }

    charts.render_ranking(divisions, -1, container, 'Division Rankings')

    return true
  },

  render_ranking: function(rows, selected, container, title) {
    rows = charts.sort(rows)
    range = charts.range(rows, selected)
    if (!range.populated) { return false }

    var data = charts.data()

    rows.forEach(function(row, index){
      if((index >= range.start) && (index <= range.end)) {
        data.addRow([index.toString(),
                     row.percent,
                     ((selected == row.id.toString() || selected == -1) ? (row.name + ' ') : '') + row.percent.toString() + '%',
                     selected == row.id.toString() ? 'opacity: .3' : 'opacity: 1'])
      }
    })

    charts.render_chart(data, container, title)
  },

  division_development_extremums: function(container) {
    var developments = charts.division_developments($division)
    if (developments.length < 2) { return false }

    charts.render_extremums(developments, container, 'Development Performance')

    return true
  },

  development_extremums: function(container) {
    var developments = charts.all_developments()
    if (developments.length < 2) { return false }

    charts.render_extremums(developments, container, 'Development Performance')

    return true
  },

  render_extremums: function(rows, container, title) {
    rows = charts.sort(rows)
    var data = charts.data()
    data.addRow(["highest", rows[0].percent,
                  rows[0].name + ' '+ rows[0].percent.toString() + '%',
                  'opacity: 1'])

    data.addRow(["lowest", rows[rows.length-1].percent,
                  rows[rows.length-1].name + ' '+ rows[rows.length-1].percent.toString() + '%',
                  'opacity: 1'])

    charts.render_chart(data, container, title)
  },

  render_chart: function(data, container, title) {
    var options = {
      title: title,
      colors: ['#002A3A'],
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
      legend: {
        position: 'none'
      },
      vAxis: {
        textPosition: 'none',
        textStyle: {
          color: 'black'
        }
      }
    }
     // Instantiate and draw our chart, passing in some options.
    var chart = new google.visualization.BarChart(document.getElementById(container));
    chart.draw(data, options)
  },


  all_developments: function() {
    var developments = []

    Object.keys($response.competition).forEach(function (division) {
      charts.division_developments(division).forEach(function(development) {
        developments.push(development)
      })
    })

    return developments
  },

  all_divisions: function() {
    var divisions = []

    Object.keys($response.competition).forEach(function (division) {
        if (division != 0) { divisions.push($response.competition[division]) }
    })

    return divisions
  },

  division_developments: function(division) {
    var developments = []

    Object.keys($response.competition[division]).forEach(function (development) {
      if (typeof($response.competition[division][development]) == 'object') {
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
    primary = $response['primary']
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Title');
    data.addColumn('number', 'Plots');
    data.addRows([
      ['Plots Invited', primary['invited']],
      ['Plots Not Invited', primary['not_invited']]
    ]);

    // Set chart options
    var options = {
      title:'Plots Invited',
      width: '100%',
      height: '100%',
      chartArea: {
            left: "3%",
            top: "3%",
            height: "100%",
            width: "100%"
        },
      pieHole: 0.4,
      slices: {
        0: { color: '#25BC18' },
        1: { color: '#E20017'}
      }
    };

    // Instantiate and draw our chart, passing in some options.
    var chart = new google.visualization.PieChart(document.getElementById('invited'));
    chart.draw(data, options);
  },

  not_invited: function() {
    primary = $response['primary']
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Title');
    data.addColumn('number', 'Plots');
    data.addRows([
      ['Plots with an Activated Resident', primary['activated'] ],
      ['Plots Pending Activation ', primary['invited'] - primary['activated'] ]
    ]);

    // Set chart options
    var options = {
      title:'Plots Activated',
      width: '100%',
      height: '100%',
      chartArea: {
            left: "3%",
            top: "3%",
            height: "100%",
            width: "100%"
        },
      pieHole: 0.4,
      colors: ['#25BC18', '#FFA700']
    };

    // Instantiate and draw our chart, passing in some options.
    var chart = new google.visualization.PieChart(document.getElementById('activated'));
    chart.draw(data, options);
  },

  overview: function() {
    primary = $response['primary']
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Title');
    data.addColumn('number', 'Plots');
    data.addRows([
      ['Plots with an Activated Resident', primary['activated'] ],
      ['Plots Pending Activation ', primary['invited'] - primary['activated'] ],
      ['Plots Not Activated ', primary['not_invited'] ]
    ]);

    // Set chart options
    var options = {
      title:'Plots Status Overview',
      width: '100%',
      height: '100%',
      chartArea: {
            left: "3%",
            top: "3%",
            height: "100%",
            width: "100%"
        },
      pieHole: 0.4,
      colors: ['#25BC18', '#FFA700', '#E20017']
    };

    // Instantiate and draw our chart, passing in some options.
    var chart = new google.visualization.PieChart(document.getElementById('overview'));
    chart.draw(data, options);
  }


}

document.addEventListener('turbolinks:load', function () {
  charts.initialise()

  var $developerSelect = $('.charts_developer_id select')
  var $divisionSelect = $('.charts_division_id select')
  var $developmentSelect = $('.charts_development_id select')
  var $phaseSelect = $('.charts_phase_id select')

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

