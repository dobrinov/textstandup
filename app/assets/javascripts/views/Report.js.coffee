class TextStandup.Views.Report extends Backbone.View
  @wrapFor: {el: '.js-report'}

  events:
    'click .js-toggle-actions-btn':            'onReportActionsToggleClick'
    'click .js-edit-report-btn':               'onEditReportBtnClick'
    'click .js-delete-report-btn':             'onDeleteReportBtnClick'
    'click .js-publish-report-btn':            'onPublishReportBtnClick'
    'click .js-cancel-report-btn':             'onCancelReportBtnClick'
    'click .js-new-item-btn':                  'onNewItemBtnClick'
    'click .js-new-item-form .js-submit-btn':  'onNewItemFormSubmitBtnClick'
    'click .js-new-item-form .js-cancel-btn':  'onNewItemFormCancelBtnClick'
    'click .js-edit-item-form .js-submit-btn': 'onEditItemFormSubmitBtnClick'
    'click .js-edit-item-form .js-cancel-btn': 'onEditItemFormCancelBtnClick'
    'click .js-item .js-edit-btn':             'onEditItemBtnClick'
    'click .js-item .js-delete-btn':           'onDeleteItemBtnClick'

  initialize: ->
    @$el.attr 'initialized', ''
    @report = @reportInitialState = @$el.data 'report'

    @actionsToggled = false
    @actionsVisible = @report.editable && !@report.edited

    @bodyContext = @initBodyContext(@reportInitialState)
    @submitEnabled = false
    @submitLoading = false

    $(document).keyup (event) => @onKeyup(event)

    Handlebars.registerPartial 'form', @formPartial()

  headerContext: ->
    {
      publishedAt: @report.published_at,
      actionsToggled: @actionsToggled,
      actionsVisible: @actionsVisible,
      user: {
        fullName: @report.user.full_name,
        initials: @report.user.initials
      }
    }

  footerContext: ->
    published = !!@report.published_at

    {
      visible: @report.edited,
      submit: {
        enabled: @submitEnabled,
        loading: @submitLoading,
        text: (if published then 'Save' else 'Publish')
      }
    }

  initBodyContext: (report) ->
    {
      sections: (
        _.map report.item_types, (type) =>
          @initSectionFor report, type
      )
    }

  initSectionFor: (report, type) ->
    items = report.items.filter (item) -> item.type == type

    {
      type: type,
      visible: report.edited || items.length > 0,
      heading: @report.locales[type].heading,
      items: (_.map (items), (item) => @initItemFor(type, true, false, item.id, item.title, item.description)),
      newItem: {
        form: @initFormFor(type, 'new'),
        button: {
          visible: report.edited,
          tooltip: @report.locales[type].newItem.tooltip,
        }
      },
    }

  initItemFor: (kind, persisted, actionsVisible, id, title, description) ->
    formType =
      if persisted
        'edit'
      else
        'new'

    {
      persisted: persisted,
      id: id,
      title: title,
      description: description,
      descriptionMarkdown: @markdownToHtml(description),
      actions: {
        visible: actionsVisible
      },
      form: @initFormFor(kind, formType)
    }

  initFormFor: (itemType, formType) ->
    submitText =
      if formType == 'new'
        'Add'
      else
        'Update'

    {
      visible: false,
      title: {value: '', placeholder: @report.locales[itemType].title.placeholder, valid: true},
      description: {value: '', placeholder: @report.locales[itemType].description.placeholder, valid: true},
      submit: {text: submitText},
    }

  onKeyup: (event) ->
    switch event.key
      when "Escape"
        @closeAllForms()
        @render()
      else

  onReportActionsToggleClick: (event) ->
    event.preventDefault()

    if @actionsToggled
      @actionsToggled = false
    else
      @actionsToggled = true

    @render()

  onEditReportBtnClick: (event) ->
    event.preventDefault()

    @report.edited = true
    @actionsVisible = false

    _.each @bodyContext.sections, (section) ->
      section.visible = true
      section.newItem.button.visible = true

      _.each section.items, (item) ->
        item.actions.visible = true

    @render()

  onDeleteReportBtnClick: (event) ->
    event.preventDefault()
    @submitReport []
    @render()

  onPublishReportBtnClick: (event) ->
    event.preventDefault()
    @submitEnabled = false
    @submitLoading = true

    items =
      _.flatten(
        _.map @bodyContext.sections, (section) ->
          _.map section.items, (item) ->
            {
              id: (if item.persisted then item.id else null),
              title: item.title,
              description: item.description,
              type: section.type
            })

    @submitReport items
    @render()

  onCancelReportBtnClick: (event) ->
    event.preventDefault()

    @$el.trigger 'cancel'

    @report.edited = false
    @actionsVisible = true
    @actionsToggled = false
    @bodyContext = @initBodyContext(@reportInitialState)

    @render()

  onNewItemBtnClick: (event) ->
    event.preventDefault()

    @closeAllForms()

    section = @sectionFromEvent event
    section.newItem.button.visible = false
    section.newItem.form.visible = true

    @render()

  onEditItemBtnClick: (event) ->
    event.preventDefault()

    @closeAllForms()

    section = @sectionFromEvent event
    id = $(event.target).closest('.js-item').data('id')
    item = _.find(section.items, (item) -> item.id == id)

    section.newItem.button.visible = false
    item.form.visible = true
    item.form.title.value = item.title
    item.form.description.value = item.description

    @render()

  onDeleteItemBtnClick: (event) ->
    event.preventDefault()

    section = @sectionFromEvent event
    id = $(event.target).closest('.js-item').data 'id'
    section.items = section.items.filter (item) -> item.id != id
    @submitEnabled = true

    @render()

  onNewItemFormSubmitBtnClick: (event) ->
    event.preventDefault()

    $form = $(event.target).closest 'form'
    title = $form.find('.js-title-input').val()
    description = $form.find('.js-description-input').val()

    section = @sectionFromEvent event
    id = "tmp_#{@unpersistedItemsCount() + 1}"
    item = section.newItem
    item.form.title.value = title
    item.form.description.value = description
    item.form.title.valid = !!item.form.title.value
    item.form.description.valid = !!item.form.description.value

    if item.form.title.valid && item.form.description.valid
      section.items.push @initItemFor(section.type, false, true, id, title, description)
      @submitEnabled = true
      @closeAllForms()
      @resetForm item.form

    @render()

  onEditItemFormSubmitBtnClick: (event) ->
    event.preventDefault()

    $form = $(event.target).closest 'form'
    title = $form.find('.js-title-input').val()
    description = $form.find('.js-description-input').val()

    section = @sectionFromEvent event
    id = $(event.target).closest('.js-item').data('id')
    item = @item id
    item.form.title.value = title
    item.form.description.value = description
    item.form.title.valid = !!item.form.title.value
    item.form.description.valid = !!item.form.description.value

    if item.form.title.valid && item.form.description.valid
      item.title = title
      item.description = description
      item.descriptionMarkdown = @markdownToHtml(description)
      @submitEnabled = true
      @closeAllForms()
      @resetForm item.form

    @render()

  onNewItemFormCancelBtnClick: (event) ->
    event.preventDefault()
    section = @sectionFromEvent(event)
    @resetForm section.newItem.form
    @closeAllForms()
    @render()

  onEditItemFormCancelBtnClick: (event) ->
    event.preventDefault()
    @closeAllForms()
    @render()

  sectionFromEvent: (event) ->
    sectionType = $(event.target).closest('.js-section').data 'type'
    _.find @bodyContext.sections, (section) -> section.type == sectionType

  resetForm: (form) ->
    form.title.value = null
    form.description.value = null
    form.title.valid = true
    form.description.valid = true

  item: (id) ->
    _.find @items(), (item) -> item.id == id

  items: ->
    _.flatten(_.map @bodyContext.sections, (section) -> section.items)

  unpersistedItemsCount: ->
    (@items().filter (item) -> !item.persisted).length

  closeAllForms: ->
    _.each @bodyContext.sections, (section) =>
      section.newItem.form.visible = false
      section.newItem.button.visible = @report.edited

      _.each section.items, (item) ->
        item.form.visible = false

  submitReport: (items) ->
    data = {report: {items: items, type: @report.type}}

    $.ajax @report.submit_path,
           type: @report.submit_method
           data: JSON.stringify(data)
           dataType: 'json'
           contentType: 'application/json'
           success: (report, textStatus, jqXHR) =>
             @$el.trigger 'submit', report
             @$el.data 'report', report
             @report = report
             @bodyContext = @initBodyContext(@report)
             @report.edited = false
             @actionsToggled = false
             @actionsVisible = true

             _.each @bodyContext.sections, (section) ->
               section.visible = section.items.length > 0
               section.newItem.button.visible = false

               _.each section.items, (item) ->
                 item.actions.visible = false

             @submitLoading = false
             @render()

           error: (jqXHR, textStatus, errorThrown) =>
             alert 'Save unsuccessul. Please, try again!'

  markdownToHtml: (value) ->
    rules = [
      [/(\b(https?|):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig, '<a href="$1" target="_blank">$1</a>'],
      [/~([a-zA-Z0-9\s]+)~/ig, '<s>$1</s>']
      [/\*([a-zA-Z0-9\s]+)\*/ig, '<strong>$1</strong>'],
      [/`([a-zA-Z0-9\s]+)`/ig, '<code>$1</code>'],
      [/\n(.*)$/ig, '<p>$1</p>'],
      [/(.*)\n/ig, '<p>$1</p>']
    ]

    _.each rules, (rule) ->
      value = value.replace rule[0], rule[1]

    value

  headerTemplate: Handlebars.compile '''
    <div class="report-header">
      <div class="avatar">{{user.initials}}</div>
      <div class="details">
        <h5 class="name">{{user.fullName}}</h5>
        <span class="date">{{publishedAt}}</span>
      </div>

      {{#if actionsVisible}}
        <div class="actions btn-group">
          {{#if actionsToggled}}
            <a href="#" class="btn btn-sm btn-outline-dark js-edit-report-btn">
              <i class="fas fa-pencil-alt"></i>
            </a>
            <a href="#" class="btn btn-sm btn-outline-danger js-delete-report-btn">
              <i class="fas fa-times"></i>
            </a>
          {{/if}}

          <a href="#" class="btn btn-sm btn-outline-secondary js-toggle-actions-btn">
            <i class="fas fa-ellipsis-h"></i>
          </a>
        </div>
      {{/if}}
    </div>
  '''

  bodyTemplate: Handlebars.compile '''
    <div class="report-body">
      {{#each sections}}
        {{#if visible}}
          <div class="section js-section" data-type="{{type}}">
            <h5>{{heading}}</h5>

            <ul>
              {{#each items}}
                <li class="item js-item" data-id="{{id}}" data-persisted="{{persisted}}">
                  {{# if form.visible}}
                    {{~> form class="js-edit-item-form" submitBtnText="Update"}}
                  {{else}}
                    <div class="item-body">
                      {{#if actions.visible}}
                        <div class="btn-group">
                          <button class="btn btn-sm btn-outline-secondary js-edit-btn js-tooltip" title="Edit">
                            <i class="fas fa-pencil-alt"></i>
                          </button>
                          <button class="btn btn-sm btn-outline-danger js-delete-btn js-tooltip" title="Delete">
                            <i class="fas fa-times"></i>
                          </button>
                        </div>
                      {{/if}}

                      <h6>{{title}}</h6>
                      <div class="description">{{{descriptionMarkdown}}}</div>
                    </div>
                  {{/if}}
                </li>
              {{/each}}

              {{#if newItem.form.visible}}
                {{~> form class="js-new-item-form" form=newItem.form}}
              {{/if}}

              {{#if newItem.button.visible}}
                <div class="new-item js-new-item-btn js-tooltip" title="{{newItem.button.tooltip}}">
                  <i class="fas fa-plus"></i>
                </div>
              {{/if}}
            </ul>
          </div>
        {{/if}}
      {{/each}}
    </div>
  '''

  formPartial: ->
    '''
      <form class="js-form {{class}}">
        <div class="form-group required">
          <label class="form-control-label">Title <abbr title="required">*</abbr></label>
          <input class="form-control js-title-input {{#unless form.title.valid}}is-invalid{{/unless}}" type="text" value="{{form.title.value}}" placeholder="{{form.title.placeholder}}">
          {{#unless form.title.valid}}
            <div class="invalid-feedback">can't be blank</div>
          {{/unless}}
        </div>

        <div class="form-group required">
          <label class="form-control-label">Description <abbr title="required">*</abbr></label>
          <textarea class="form-control js-description-input {{#unless form.description.valid}}is-invalid{{/unless}}" rows="5" placeholder="{{form.description.placeholder}}">{{form.description.value}}</textarea>
          {{#unless form.description.valid}}
            <div class="invalid-feedback">can't be blank</div>
          {{/unless}}
          <div class="md-hints">
            <strong>*bold*</strong>
            ~<s>strike</s>~
            <code>`code`</code>
          </div>
        </div>

        <div class="form-group">
          <a class="btn btn-outline-primary js-submit-btn" href="#">{{form.submit.text}}</a>
          <a class="btn btn-outline-secondary js-cancel-btn" href="#">Cancel</a>
        </div>
      </form>
    '''

  footerTemplate: Handlebars.compile '''
    {{#if visible}}
      <div class="report-footer">
        <a href="#" class="btn {{#if submit.enabled}}btn-primary{{else}}btn-outline-primary disabled{{/if}} js-publish-report-btn">
          {{#if submit.loading}}
            <i class="fas fa-sync-alt fa-spin"></i>
          {{else}}
            {{submit.text}}
          {{/if}}
        </a>
        <a href="#" class="btn btn-outline-secondary js-cancel-report-btn">Cancel</a>
      </div>
    {{/if}}
  '''

  render: ->
    @$('.js-tooltip').tooltip 'dispose'

    @$el.hide()
    @$el.empty()
    @$el.append @headerTemplate @headerContext()
    @$el.append @bodyTemplate @bodyContext
    @$el.append @footerTemplate @footerContext()
    @$el.show()

    TextStandup.initializeElement @$('.js-button-dialog')

    if @report.edited
      @$el.addClass('report-edited')
      @$('form .form-control').first().focus()
      @$('.js-tooltip').tooltip()

    else
      @$el.removeClass('report-edited')

      if @items().length == 0
        @$el.slideUp 100, => @$el.remove()
