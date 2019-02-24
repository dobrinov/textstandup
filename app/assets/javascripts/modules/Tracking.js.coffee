window.TextStandup.Tracking =
  initialize: (element) ->
    _.each $(element).find('.js-tracked'), (tracked) ->
      $(tracked).on 'click', (event) ->
        data = $(tracked).data()
        TextStandup.Tracking.track data.category,
                                   data.action,
                                   data.label,
                                   data.value

  track: (category, action, label, value) ->
    console.log category, action, label, value
    return false unless ga?
    ga 'send', 'event', category, action, label, value
