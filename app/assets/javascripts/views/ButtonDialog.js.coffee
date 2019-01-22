class TextStandup.Views.ButtonDialog extends Backbone.View
  @wrapFor: {el: '.js-button-dialog'}

  events:
    'click .js-trigger': 'onTriggerClick'
    'click .js-close': 'onCloseClick'

  onTriggerClick: (event) ->
    event.preventDefault()
    @show()

  onCloseClick: (event) ->
    event.preventDefault()
    @hide()

  show: ->
    @dialogOpen = true
    @render()

  hide: ->
    @dialogOpen = false
    @render()

  initialize: ->
    @reference = @$('.js-trigger')
    @dialog = $('.js-button-dialog-content')
    @content = @$('.js-content').html()
    @popper = null
    @dialogOpen = false

    $(document).on 'click', (event) =>
      target = $(event.target)

      unless target.parents(@dialog).length > 0 || target.is(@reference)
        @hide()

  render: ->
    if @dialogOpen
      @dialog.find('.js-content').html @content
      TextStandup.initializeElement @dialog

      @dialog.find('.js-close').on 'click', (event) =>
        event.preventDefault()
        @hide()

      @dialog.show()

      @popper = new Popper @reference,
                           @dialog,
                           {
                             placement: 'bottom',
                             modifiers: {
                               flip: {
                                 behavior: ['bottom', 'top']
                               },
                               arrow: {
                                 element: '.js-arrow'
                               },
                               offset: {
                                 offset: '12, 12',
                               },
                               preventOverflow: {
                                 padding: 15
                               },
                             }
                           }

    else
      @dialog.hide()
      @dialog.find('.js-content').empty()
