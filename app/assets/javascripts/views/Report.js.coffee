class TextStandup.Views.Report extends Backbone.View
  @wrapFor: {el: '.js-report'}

  events:
    'click .js-item .js-delete': 'deleteItem'
    'click .js-new': 'openNewItemForm'
    'click .js-edit': 'openEditItemForm'
    'click .js-cancel': 'closeAllForms'

  initialize: ->
    @preloader = true

    @itemsUrl = @$el.data('items-url')

    @itemsContainer = @$('.js-items')
    @items = []

    @newItemButton = @$('.js-new')

    @newItemButtonVisible = true
    @newItemFormVisible = false
    @editItemFormVisible = false
    @editItem = null

    @deleteItemUrl = ''

    Handlebars.registerPartial 'itemUrl', decodeURIComponent(@$el.data('item-url'))

    @getItems()

  taskFormTemplate: Handlebars.compile '''
    <form action="{{action}}">
      <div class="form-group">
        <label for="title">Title</label>
        <input type="text" name="title" value="{{title}}" class="form-control" />
      </div>
      <div class="form-group">
        <label for="summary">Summary</label>
        <textarea name="summary" rows="4" class="form-control">{{summary}}</textarea>
      </div>
      <div class="form-group">
        <input type="submit" value="{{submit_text}}" class="btn btn-primary" />
        <a class="btn btn-outline-secondary js-cancel">Cancel</a>
      </div>
    </form>
  '''

  formTemplate: Handlebars.compile '''
  '''

  preloaderTemplate: Handlebars.compile '''
    <div class="preloader">
      <div class="sk-three-bounce">
        <div class="sk-child sk-bounce1"></div>
        <div class="sk-child sk-bounce2"></div>
        <div class="sk-child sk-bounce3"></div>
      </div>
    </div>
  '''

  itemsTemplate: Handlebars.compile '''
    {{#if items}}
      <ol>
        {{#each items}}
          <li class="js-item" data-id="{{id}}">
            <h4 class="js-title">{{title}}</h4>
            <p class="js-summary">{{summary}}</p>

            <div class="btn-group">
              <a href="{{> itemUrl id=id}}" class="js-edit btn btn-sm btn-outline-secondary">
                <i class="fas fa-pencil-alt"></i>
              </a>
              <a href="{{> itemUrl id=id}}" class="js-delete btn btn-sm btn-outline-danger">
                <i class="fas fa-times"></i>
              </a>
            </div>
          </li>
        {{/each}}
      </ol>
    {{else}}
      <div class="empty">Empty</div>
    {{/if}}
  '''

  openNewItemForm: (e) ->
    e.preventDefault()
    @newItemButtonVisible = false
    @newItemFormVisible = true
    @render()

  openEditItemForm: (e) ->
    e.preventDefault()
    @editItemFormVisible = true
    @newItemFormVisible = false
    @newItemButtonVisible =  false
    item = $(e.target).closest('.js-item')
    @editItem = {id: item.data('id'), title: item.find('.js-title').html(), summary: item.find('.js-summary').html()}
    console.log @editItem
    @render()

  closeAllForms: ->
    @newItemButtonVisible = true
    @newItemFormVisible = false
    @editItemFormVisible = false
    @editItem = null
    @render()

  getItems: ->
    @preloader = true
    @render()

    $.ajax @itemsUrl,
           success: (items) =>
             @items = items

           error: (xhr, y, z) ->
             @items = []
             console.log 'fail'

           complete: =>
             @preloader = false
             @render()

  createItem: (e) ->
    e.preventDefault()
    $.ajax @createItemUrl,
           method: 'post'
           data: @newItemForm.serialize()
           success: => alert('todo')
           error: (xhr, y, z) -> console.log(xhr.responseJSON)

  updateItem: (e) ->
    e.preventDefault()
    $.ajax @editItemForm.attr('action'), method: 'patch'

  deleteItem: (e) ->
    e.preventDefault()

    item = $(e.target).closest '.js-item'
    id = item.data('id')

    $.ajax $(e.target).closest('a').attr('href'),
      method: 'delete',
      success: =>
        @items = @items.filter (item) -> item.id != id

      error: (xhr, y, z) ->
        console.log 'fail'

      complete: =>
        @render()

  render: ->
    @itemsContainer.empty()

    if @preloader
      setTimeout (=>
        return unless @itemsContainer.is(':empty')
        return if @itemsContainer.find('.preloader').length > 0
        @itemsContainer.append @preloaderTemplate()
      ), 100
    else
      @itemsContainer.append @itemsTemplate(items: @items)

    if @newItemFormVisible
      @itemsContainer.append @taskFormTemplate(action: '', title: '', summary: '', submit_text: 'Create')

    if @editItemFormVisible
      itemContainer = @itemsContainer.find('.js-item[data-id=' + @editItem.id + ']')
      itemContainer.empty()
      itemContainer.html @taskFormTemplate(action: '', title: @editItem.title, summary: @editItem.summary, submit_text: 'Update')

    if @newItemButtonVisible
      @newItemButton.show()
    else
      @newItemButton.hide()
