function record_event(activity, category1, category2) {
  $.post({
    url: '/homeowners/analytics_event',
    data: { "activity" : activity,
            "category1" : category1,
            "category2" : category2 },
    dataType: 'json',
  })
}
