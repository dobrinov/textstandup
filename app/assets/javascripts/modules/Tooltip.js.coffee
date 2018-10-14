window.TextStandup.Tooltip =
  initialize: (element) ->
    $(element).find('[data-toggle="tooltip"]').tooltip()
