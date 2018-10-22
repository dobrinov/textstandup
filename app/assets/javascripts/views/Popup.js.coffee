class TextStandup.Views.Popup extends Backbone.View
  @wrapFor: {el: '.js-popup'}

  events:
    'click .js-popup-trigger': 'show'
    'click .js-popup-close': 'hide'

  initialize: ->
    @content = @$('.js-popup-content')
    @visible = false

    $(window).click (event) =>
      @hide() if @$el.has($(event.target)).length == 0

  show: (event) ->
    @visible = true
    @render()

  hide: (event) ->
    @visible = false
    @render()

  render: ->
    if @visible
      @content.show()
    else
      @content.hide()
