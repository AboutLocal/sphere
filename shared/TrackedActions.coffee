EVENT_TYPE = {
  LOGIN: 0,
  LOGOUT: 1,
  SEARCH: 2,
  FILTER: 3,
  FLAGGED: 4,
  ANSWERED_FEEDBACK: 5,
  ANALYTICS_TEASER_CLICK: 6,
  EXPORT_STARTED: 7,
  EXPORT_COMPLETED: 8,
  PROFILE_VIEW: 9,
  PROFILE_DETAILS_VIEW: 10,
  PAGE_VIEW: 11
}

TrackedAction = {};

(() ->

  _pkg = TrackedAction;

  class _Event
    timestamp: null
    userId: null

  class _TransactionEvent extends _Event
    transactionId: null

  class _pkg.Login extends _Event
    type: EVENT_TYPE.LOGIN

  class _pkg.Logout extends _Event
    type: EVENT_TYPE.LOGOUT

  class _pkg.Search extends _Event
    type: EVENT_TYPE.SEARCH
    companyName: null

  class _pkg.Filter extends _Event
    type: EVENT_TYPE.FILTER
    activeTab: null
    activeFilters: []

  class _pkg.Flagged extends _Event
    type: EVENT_TYPE.FLAGGED
    companyId: null
    flagId: null

  class _pkg.AnsweredFeedback extends _Event
    type: EVENT_TYPE.ANSWERED_FEEDBACK

  class _pkg.AnalyticsTeaserClick extends _Event
    type: EVENT_TYPE.ANALYTICS_TEASER_CLICK

  class _pkg.ExportStarted extends _TransactionEvent
    type: EVENT_TYPE.EXPORT_STARTED
    companyIds: []

  class _pkg.ExportCompleted extends _TransactionEvent
    type: EVENT_TYPE.EXPORT_COMPLETED

  class _pkg.ProfileView extends _Event
    type: EVENT_TYPE.PROFILE_VIEW
    companyId: null

  class _pkg.ProfileDetailsView extends _Event
    type: EVENT_TYPE.PROFILE_DETAILS_VIEW
    companyId: null
    sectionId: null

  class _pkg.PageView extends _Event
    type: EVENT_TYPE.PAGE_VIEW
    page: null

)()
