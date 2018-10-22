class TextStandup.Views.InvitationLinkGenerator extends Backbone.View
  @wrapFor: {el: '.js-invitation-link-generator'}

  events:
    'click .js-generation-bnt': 'generate'
    'click .js-copy-to-clipboard': 'copyUrlToClipboard'

  initialize: ->
    @generatedLinks = @$('.js-generated-links')
    @btn = @$('.js-generation-bnt')
    @url = @btn.attr 'href'
    @links = []
    @linkLimitReached = false
    @linkLimit = 3

  generatedLinkTemplate: Handlebars.compile '''
    <div class="input-group mb-3">
      <input type="text" class="form-control" value="{{link}}">
      <div class="input-group-append">
        <button class="btn btn-outline-secondary js-copy-to-clipboard" type="button">
          <i class="fas fa-link"></i>
        </button>
      </div>
    </div>
  '''

  generate: (event) ->
    event.preventDefault()

    $.ajax @url,
      method: 'post'
      error: (_, textStatus, errorThrown) =>
        @render()

      success: (link, _a, _b) =>
        @links.push link
        @linkLimitReached = true if @links.length >= @linkLimit
        @render()

  copyUrlToClipboard: (event) ->
    $(event.target).closest('.input-group').find('input').select()
    document.execCommand 'copy'

  render: ->
    @generatedLinks.empty()
    $.each @links, (index, link) =>
      @generatedLinks.append @generatedLinkTemplate(link: link.url)

    @btn.hide() if @linkLimitReached
