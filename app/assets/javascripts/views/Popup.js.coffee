class TextStandup.Views.Popup extends Backbone.View
  @wrapFor: {el: '.js-popup'}

  events:
    'click .js-popup-trigger': 'show'
    'click .js-popup-close': 'hide'

  initialize: ->
    @trigger = @$('.js-popup-trigger')
    @content = @$('.js-popup-content')

    @visible = false

    $(window).click (event) =>
      @hide() if @$el.has($(event.target)).length == 0

  show: (event) ->
    event.preventDefault()

    @visible = true
    @render()

  hide: ->
    @visible = false
    @render()

  contentTopOffset: ->
    top = -(@content.outerHeight() - @trigger.outerHeight()) / 2

    spaceToTopBoundary = @trigger.offset().top - $(window).scrollTop() + top
    spaceToBottomBoundary = $(window).outerHeight() - spaceToTopBoundary - @content.outerHeight()

    if spaceToBottomBoundary < 15
      top + spaceToBottomBoundary - 15
    else
      top

  contentLeftOffset: ->
    left = -(@content.outerWidth() - @trigger.outerWidth()) / 2

    spaceToLeftBoundary = @trigger.offset().left - $(window).scrollLeft() + left
    spaceToRightBoundary = $(window).outerWidth() - spaceToLeftBoundary - @content.outerWidth()

    if spaceToRightBoundary < 15
      left + spaceToRightBoundary - 15
    else
      left

  contentSpaceToBottom: ->

  contentSpaceToRight: ->

  render: ->
    # Reduce size if bigger than screen
    if @content.outerWidth() > $(window).outerWidth() - 30
      @content.outerWidth $(window).outerWidth() - 30

    if @content.outerHeight() > $(window).outerHeight() - 30
      @content.outerHeight $(window).outerHeight() - 30

    @content.css 'top', "#{@contentTopOffset()}px"
    @content.css 'left', "#{@contentLeftOffset()}px"

    if @visible
      @content.show()
    else
      @content.hide()
