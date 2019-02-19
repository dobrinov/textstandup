class TextStandup.Views.Feed extends Backbone.View
  @wrapFor: {el: '.js-feed'}

  events:
    'click .js-new-report-btn': 'onNewReportBtnClick'
    'click .js-new-morning-report-btn': 'onNewMorningReportBtnClick'
    'click .js-new-delivery-report-btn': 'onNewDeliveryReportBtnClick'
    'submit .js-report': 'onReportSubmit'

  initialize: ->
    args = @$el.data 'initialize'

    @reports = args.reports
    @postingEnabled = args.today
    @blankMorningReport = args.blank_morning_report
    @blankDeliveryReport = args.blank_delivery_report

    @posterVisible = @reports.length == 0
    @newReportBtnVisible = @postingEnabled && !@posterVisible
    @posterNewReportBtnVisible = @postingEnabled && @posterVisible
    @newReportDialogVisible = false
    @newMorningReportDialogVisible = false
    @newDeliveryReportDialogVisible = false

  onNewReportBtnClick: (event) ->
    event.preventDefault()
    @posterVisible = false
    @newReportBtnVisible = false
    @newReportDialogVisible = true
    @render()

  onNewMorningReportBtnClick: (event) ->
    event.preventDefault()
    @posterVisible = false
    @newReportDialogVisible = false
    @newMorningReportDialogVisible = true
    @render()

  onNewDeliveryReportBtnClick: (event) ->
    event.preventDefault()
    @posterVisible = false
    @newReportDialogVisible = false
    @newDeliveryReportDialogVisible = true
    @render()

  onReportSubmit: (event, submittedReport) ->
    event.preventDefault()
    submittedReport.edited = false

    @reports = _.reject @reports, (report) -> submittedReport.id == JSON.parse(report).id

    if submittedReport.items.length > 0
      console.log 'in'
      @reports.unshift JSON.stringify(submittedReport)

    @posterVisible = @reports.length == 0
    @posterNewReportBtnVisible = @postingEnabled && @posterVisible
    @newReportDialogVisible = false
    @newReportBtnVisible = true
    @newMorningReportDialogVisible = false
    @newDeliveryReportDialogVisible = false

    @render()

  onReportCancel: (event) ->
    event.preventDefault()
    @posterVisible = true
    @newMorningReportDialogVisible = false
    @newDeliveryReportDialogVisible = false
    @render()

  template: Handlebars.compile '''
    {{#if dialog.visible}}
      <div class="new-report-dialog">
        <i class="fas fa-feather-alt"></i>
        <h2>Post a new report</h2>
        <p>What kind of report you want to post?</p>

        <ul>
          <li>
            <a href="#" class="js-new-morning-report-btn">
              <i class="fas fa-coffee"></i>
              <span>Morning report</span>
            </a>
          </li>
          <li>
            <a href="#" class="js-new-delivery-report-btn">
              <i class="fas fa-truck"></i>
              <span>Delivery report</span>
            </a>
          </li>
        </ul>
      </div>
    {{/if}}

    {{#if morningReport.visible}}
      <div class="report js-report js-new-report" data-report="{{morningReport.data}}"></div>
    {{/if}}

    {{#if deliveryReport.visible}}
      <div class="report js-report js-new-report" data-report="{{deliveryReport.data}}"></div>
    {{/if}}

    {{#if poster.visible}}
      <div class="alert alert-info empty-poster">
        <i class="fas fa-umbrella-beach"></i>
        <h2>No reports today</h2>
        <p>Sorry, no reports have been posted on this date.</p>

        {{#if poster.newPostBtn.visible}}
          <a href="#" class="btn btn-primary js-new-report-btn">Post a new report</a>
        {{/if}}
      </div>
    {{else}}
      {{#if newPostBtn.visible}}
        <a href="#" class="btn btn-outline-primary btn-lg mb-3 js-new-report-btn" title="Post a new report">
          <i class="fas fa-plus"></i>
        </a>
      {{/if}}

      <ul class="reports js-reports">
        {{#each reports}}
          <li class="report js-report" data-report="{{this}}"></li>
        {{/each}}
      </ul>
    {{/if}}
  '''

  templateContext: ->
    {
      reports: @reports,
      newPostBtn: {
        visible: @newReportBtnVisible,
      },
      poster: {
        visible: @posterVisible,
        newPostBtn: {
          visible: @posterNewReportBtnVisible
        }
      },
      dialog: {
        visible: @newReportDialogVisible
      },
      morningReport: {
        visible: @newMorningReportDialogVisible,
        data: @blankMorningReport
      },
      deliveryReport: {
        visible: @newDeliveryReportDialogVisible,
        data: @blankDeliveryReport
      }
    }

  render: ->
    @$el.html @template @templateContext()

    TextStandup.initializeElement @$('.js-report:not([initialized])')

    @$('.js-report').on 'submit', (event, report) => @onReportSubmit(event, report)
    @$('.js-report').on 'cancel', (event, report) => @onReportCancel(event)
