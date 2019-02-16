class TextStandup.Views.NewReport extends Backbone.View
  @wrapFor: {el: '.js-new-report'}

  events:
    'click .js-new-report-btn':          'onNewReportBtnClick'
    'click .js-new-morning-report-btn':  'onNewMorningReportBtnClick'
    'click .js-new-delivery-report-btn': 'onNewDeliveryReportBtnClick'

  initialize: ->
    @morningReport = @$el.data 'morning-report'
    @deliveryReport = @$el.data 'delivery-report'
    @buttonVisible = true
    @buttonEnabled = true
    @dialogVisible = false
    @morningReportVisible = false
    @deliveryReportVisible = false

  onNewReportBtnClick: (event) ->
    event.preventDefault()
    @dialogVisible = true
    @buttonEnabled = false
    @render()

  onNewMorningReportBtnClick: (event) ->
    event.preventDefault()
    @dialogVisible = false
    @buttonVisible = false
    @deliveryReportVisible = false
    @morningReportVisible = true
    @render()

  onNewDeliveryReportBtnClick: (event) ->
    event.preventDefault()
    @dialogVisible = false
    @buttonVisible = false
    @morningReportVisible = false
    @deliveryReportVisible = true
    @render()

  templateContext: ->
    {
      button: {
        visible: @buttonVisible,
        enabled: @buttonEnabled
      }
      dialog: {
        visible: @dialogVisible
      }
      morningReport: {
        data: JSON.stringify(@morningReport),
        visible: @morningReportVisible
      }
      deliveryReport: {
        data: JSON.stringify(@deliveryReport),
        visible: @deliveryReportVisible
      }
    }

  template: Handlebars.compile '''
    <div class="new-report-btn-container">
      {{#if button.visible}}
        <a href="#" class="btn btn-primary js-new-report-btn {{#unless button.enabled}}disabled{{/unless}}">New report</a>
      {{/if}}

      {{#if dialog.visible}}
        <div class="new-report-dialog">
          <a href="#" class="js-new-morning-report-btn">
            <i class="fas fa-coffee"></i>
            <span>Morning report</span>
          </a>
          <a href="#" class="js-new-delivery-report-btn">
            <i class="fas fa-truck"></i>
            <span>Delivery report</span>
          </a>
        </div>
      {{/if}}

      {{#if morningReport.visible}}
        <div class="report js-report" data-report="{{morningReport.data}}"></div>
      {{/if}}

      {{#if deliveryReport.visible}}
        <div class="report js-report" data-report="{{deliveryReport.data}}"></div>
      {{/if}}
    <div>
  '''

  render: ->
    @$el.empty()
    @$el.append @template @templateContext()
    TextStandup.initializeElement @$('.js-report')

    @$('.js-report').on 'submit', (event) =>
      event.preventDefault()
      @$el.after $(event.target)

    @$('.js-report').on 'submit cancel', (event) =>
      event.preventDefault()
      @buttonVisible = true
      @buttonEnabled = true
      @dialogVisible = false
      @morningReportVisible = false
      @deliveryReportVisible = false
      @render()
