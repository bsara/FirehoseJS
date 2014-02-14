class Firehose.Company extends Firehose.Object
  
  
  # @nodoc
  @_firehoseType: "Company"
  
  ###
  @property [string] 
  ###
  title: null
  
  ###
  @property [string] 
  ###
  token: null
  
  ###
  @property [Date] 
  ###
  lastFetchAt: null
  
  ###
  @property [boolean] 
  ###
  fetchAutomatically: true
  
  ###
  @property [string] 
  ###
  forwardingEmailAddress: null
  
  ###
  @property [string] 
  ###
  knowledgeBaseSubdomain: null
  
  ###
  @property [string] 
  ###
  knowledgeBaseCustomDomain: null
  
  ###
  @property [integer] 
  ###
  unresolvedCount: 0
  
  ###
  @property [integer] 
  ###
  numberOfAccounts: 0
  
  
  # associations
  
  ###
  @property [Array<Agent>] 
  ###
  agents: null
  
  ###
  @property [Array<AgentInvite>] 
  ###
  agentInvites: null
  
  ###
  @property [Array<Tag>] 
  ###
  tags: null
  
  ###
  @property [Array<CannedResponse>] 
  ###
  cannedResponses: null
  
  
  # remote arrays
  
  # @nodoc
  _customers: null
  
  # @nodoc
  _notifications: null
  
  # @nodoc
  _twitterAccounts: null
  
  # @nodoc
  _facebookAccounts: null
  
  # @nodoc
  _emailAccounts: null
  
  # @nodoc
  _articles: null
  
  
  # billing
  
  ###
  @property [CreditCard] 
  ###
  creditCard: null
  
  ###
  @property [string] 
  ###
  billingEmail: null
  
  ###
  @property [float] 
  ###
  billingRate: 8.0
  
  ###
  @property [Date] 
  ###
  trialExpirationDate: null
  
  ###
  @property [Array<Object>] Contains all the discounts for a billing account. Each object will have 4 keys: `name`, `applyType`, `amount`, `expirationDate`. `applyType` will be either `percentage` or `fixed amount`.
  ###
  discounts: null
  
  ###
  @property [Date] 
  ###
  nextBillingDate: null
  
  ###
  @property [boolean] 
  ###
  isGracePeriodOver: false
  
  ###
  @property [integer] 
  ###
  daysLeftInGracePeriod: -1
  
  ###
  @property [boolean] 
  ###
  isCurrent: false
  
  ###
  @property [boolean] 
  ###
  hasSuccessfulBilling: false
  
  
  # protected
  
  # @nodoc
  _creator: null
    
    
  # @nodoc
  _setup: ->
    @agents           = new Firehose.UniqueArray
    @agentInvites     = new Firehose.UniqueArray
    @tags             = new Firehose.UniqueArray
    @cannedResponses  = new Firehose.UniqueArray

    @agents.sortOn "firstName"
    @tags.sortOn "label"
    @cannedResponses.sortOn "name"
    
    
  ###
  Create a brand new company with a title and an optional creator.
  @param title [string] The title of the company.
  @param creator [Agent] The creator of the company. You can leave blank and it will make the current agent the creator.
  ###    
  @companyWithTitle: (title, creator) ->
    Firehose.Object._objectOfClassWithID Firehose.Company,
      title:    title
      _creator: creator || Firehose.Agent.loggedInAgent
  
  
  ###
  Create a company object when all you have is an id. You can then fetch articles or fetch the companies properties if you're authenticated as an agent of the company.
  @param id [number] The id of the company.
  @return [Company] Returns a company object. If a company object with this id already exists in the cache, it will be returned.
  ###    
  @companyWithID: (id, creator) ->
    Firehose.Object._objectOfClassWithID Firehose.Company,
      id:       id
      _creator: creator
      
      
  ###
  Create a company object when all you have is the subdomain for the knowledge base. You can then call `fetch` to get the company's `id` and `title`.
  @param subdomain [string] The subdomain of the company
  @return [Company] Returns a company object you can then call `fetch` on.
  ###    
  @companyWithKBSubdomain: (subdomain) ->
    Firehose.Object._objectOfClassWithID Firehose.Company,
      knowledgeBaseSubdomain: subdomain
      
      
  ###
  Create a company object when all you have is the custom domain for the knowledge base. You can then call `fetch` to get the company's `id` and `title`.
  @param customDomain [string] The custom domain that maps (via a CNAME DNS record) to the subdomain of the company's kb.
  @return [Company] Returns a company object you can then call `fetch` on.
  ###    
  @companyWithKBCustomDomain: (customDomain) ->
    Firehose.Object._objectOfClassWithID Firehose.Company,
      knowledgeBaseCustomDomain: customDomain
      
    
  ###
  Fetch a companies properties based on `id`, `knowledgeBaseSubdomain` or `knowledgeBaseCustomDomain`.
  @returns [jqXHR Promise] Promise
  ###
  fetch: ->
    if @id?
      request = 
        route: "companies/#{@id}"
        
    else if @knowledgeBaseSubdomain
      request = 
        auth:   false
        route:  "companies"
        params: 
          kb_subdomain: @knowledgeBaseSubdomain
       
    else if @knowledgeBaseCustomDomain
      request = 
        auth:   false
        route:  "companies"
        params: 
          kb_custom_domain: @knowledgeBaseCustomDomain
    
    else
      throw "You can't call 'fetch' on a company unless 'id', 'knowledgeBaseSubdomain' or 'knowledgeBaseCustomDomain' is set."
      
    Firehose.client.get( request ).done (data) =>
      this._populateWithJSON data
 
  ###
  Persists any changes you've made to the company to the server. Properties that can be updated: `title`, `fetch_automatically`
  @returns [jqXHR Promise] Promise
  ###
  save: ->
    if @id?
      params = 
        route: "companies/#{@id}"
        body:  this._toJSON()
      Firehose.client.put( params )
    else
      params = 
        route: "agents/#{@_creator.id}/companies"
        body:  this._toJSON()
      Firehose.client.post( params ).done (data) =>
        this._populateWithJSON data
    
    
  ###
  Force a company to fetch it's accounts right now. (otherwise it's about every 10 minutes if `fetch_automatically` is true)
  @returns [jqXHR Promise] Promise
  ###
  forceChannelsFetch: ->
    params = 
      route: "companies/#{@id}/force_channels_fetch"
    Firehose.client.put( params )
    
    
  ###
  Destroy a company. This will destroy all data associated with the company, including customers, interactions, notes, etc. It is asynchronous, so it will
  not be deleted immediately but in the background over the course of possibly an hour.
  @returns [jqXHR Promise] Promise
  ###
  destroy: ->
    params = 
      route: "companies/#{@id}"
    Firehose.client.delete( params ).done =>
      Firehose.Agent.loggedInAgent.companies.dropObject this
    
    
  customersWithCriteria: (criteria) ->
    criteria ?= {}
    params =
      filter:       if criteria.everything? and criteria.everything then "everything" else "unresolved"
      channel:      criteria.channels.join(",") if criteria.channels?
      sort:         if criteria.sort? then criteria.sort else "newest_first"
      search_text:  encodeURIComponent( criteria.searchString ) if criteria.searchString
    customers = new Firehose.RemoteArray "companies/#{@id}/customers", params, (json) =>
      Firehose.Customer.customerWithID( json.id, this )
    if params.sort == 'newest_first'
      customers.sortOn "newestInteractionReceivedAt", "desc"
    else
      customers.sortOn "newestInteractionReceivedAt", "asc"
    customers.onceParams = { pre_fetch: criteria.preFetch } if criteria.preFetch?
    customers
      
      
  notifications: ->
    unless @_notifications?
      this._setIfNotNull "_notifications", new Firehose.RemoteArray "companies/#{@id}/notifications", null, (json) =>
        Firehose.Notification._notificationWithID( json.id, this )
      @_notifications.sortOn "title"
    @_notifications
    
    
  # The Twitter accounts of a company
  # @return [RemoteArray<TwitterAccount>] the Twitter accounts
  twitterAccounts: ->
    unless @_twitterAccounts?
      this._setIfNotNull "_twitterAccounts", new Firehose.RemoteArray "companies/#{@id}/twitter_accounts", null, (json) =>
        Firehose.TwitterAccount._twitterAccountWithID( json.id, this )
      @_twitterAccounts.sortOn "screenName"
    @_twitterAccounts
    
  
  facebookAccounts: ->
    unless @_facebookAccounts?
      this._setIfNotNull "_facebookAccounts", new Firehose.RemoteArray "companies/#{@id}/facebook_accounts", null, (json) =>
        Firehose.FacebookAccount._facebookAccountWithID( json.id, this )
      @_facebookAccounts.sortOn "name"
    @_facebookAccounts
    
    
  emailAccounts: ->
    unless @_emailAccounts?
      this._setIfNotNull "_emailAccounts", new Firehose.RemoteArray "companies/#{@id}/email_accounts", null, (json) =>
        Firehose.EmailAccount._emailAccountWithID( json.id, this )
      @_emailAccounts.sortOn "username"
    @_emailAccounts
    
    
  articles: ->
    unless @_articles?
      articlesRemoteArray = new Firehose.RemoteArray "companies/#{@id}/articles", null, (json) =>
        Firehose.Article.articleWithID( json.id, this )
      articlesRemoteArray.auth = false
      this._setIfNotNull "_articles", articlesRemoteArray
      @_articles.sortOn "title"
    @_articles
             
  
  addAgent: (agent) ->
    params = 
      route: "companies/#{@id}/agents/#{agent.id}"
    Firehose.client.put( params ).done =>
      @agents.insertObject agent
    
  
  removeAgent: (agent) ->
    params = 
      route: "companies/#{@id}/agents/#{agent.id}"
    Firehose.client.delete( params ).done =>
      @agents.dropObject agent
    
    
  ###
  Fetches the billing info for the company from the billing server.
  This will populate `discounts` with a list of discount objects each having the follower properties:
    name: [string] The name of the discount.
    applyType: [string] either "percentage" or "fixed amount"
    amount: [number] The percentage or fixed amount to discount from the total price.
    expirationDate: [Date] When the discount expires and should not longer be applied to the monthly billing.
  ###
  fetchBillingInfo: ->
    fetchBlock = =>
      Firehose.client.billingAccessToken = @token 
      params = 
        server: "billing"
        route: "entities/#{@id}"
      Firehose.client.get( params ).done (json) =>
        if json.credit_card?
          this._setIfNotNull "creditCard", Firehose.CreditCard.creditCardWithID( json.credit_card.id, this )
          @creditCard._populateWithJSON json.credit_card
        this._setIfNotNull "billingEmail",          json.email || Firehose.Agent.loggedInAgent.email
        this._setIfNotNull "billingRate",           (json.rate / 100.0).toFixed(2)
        this._setIfNotNull "trialExpirationDate",   Date.parse( json.free_trial_expiration_date ) || new Date(+new Date + 12096e5) # 14 days away
        this._setIfNotNull "nextBillingDate",       if json.next_bill_date then Date.parse( json.next_bill_date )
        this._setIfNotNull "isGracePeriodOver",     json.grace_period_over
        this._setIfNotNull "daysLeftInGracePeriod", json.days_left_in_grace_period
        this._setIfNotNull "isCurrent",             json.current
        this._setIfNotNull "hasSuccessfulBilling",  json.has_successful_billing
        @discounts = []
        for discount in json.discount_list
          @discounts.push
            name:           discount.name
            applyType:      discount.apply_type
            amount:         discount.amount
            expirationDate: if discount.expiration_date then Date.parse( discount.expiration_date )
    if @token
      fetchBlock()
    else
      this.fetch().then ->
        fetchBlock()
    
    
  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "title",                     json.title
    this._setIfNotNull "token",                     json.token                                   unless @token?
    this._setIfNotNull "fetchAutomatically",        json.company_settings?.fetch_automatically
    this._setIfNotNull "lastFetchAt",               json.last_fetch_at
    this._setIfNotNull "forwardingEmailAddress",    json.forwarding_email                        unless @forwardingEmailAddress?
    this._setIfNotNull "knowledgeBaseSubdomain",    json.company_settings?.kb_subdomain
    this._setIfNotNull "knowledgeBaseCustomDomain", json.company_settings?.kb_custom_domain
    this._setIfNotNull "unresolvedCount",           json.unresolved_count
    this._setIfNotNull "numberOfAccounts",          json.number_of_accounts
    
    this._populateAssociatedObjects this, "agents", json.agents, (json) =>
      agent = Firehose.Agent.agentWithID( json.id )
      agent.companies.insertObject this
      agent
      
    this._populateAssociatedObjects this, "agentInvites", json.agent_invites, (json) =>
      Firehose.AgentInvite._agentInviteWithID( json.id, this )
      
    this._populateAssociatedObjects this, "tags", json.tags, (json) =>
      Firehose.Tag._tagWithID( json.id, this )
      
    this._populateAssociatedObjects this, "cannedResponses", json.canned_responses, (json) =>
      Firehose.CannedResponse._cannedResponseWithID( json.id, this )
      
    Firehose.client.billingAccessToken = @token
    
    super json
    
    
  # @nodoc
  _toJSON: ->
    company:
      title:                @title
      fetch_automatically:  @fetchAutomatically
      

  # @nodoc
  _toArchivableJSON: ->
    $.extend super(),
      title:                @title
      token:                @token
      fetch_automatically:  @fetchAutomatically
      last_fetch_at:        @lastFetchAt
      forwarding_email:     @forwardingEmailAddress
      kb_subdomain:         @knowledgeBaseSubdomain
      unresolved_count:     @unresolvedCount
      number_of_accounts:   @numberOfAccounts
      # agents:               @agents._toArchivableJSON()   # gotta figure out how to imp this so it doesn't recurse infinitely
      agent_invites:        @agentInvites._toArchivableJSON()
      tags:                 @tags._toArchivableJSON()
      canned_responses:     @cannedResponses._toArchivableJSON()
