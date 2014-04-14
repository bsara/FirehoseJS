class Firehose.Company extends Firehose.Object
  
  
  # @nodoc
  @_firehoseType: "Company"
  
  ###
  @property [String] 
  ###
  title: null
  
  ###
  @property [String] 
  ###
  token: null
  
  ###
  @property [Date] 
  ###
  lastFetchAt: null
  
  ###
  @property [String] 
  ###
  forwardingEmailAddress: null
  
  ###
  @property [integer] 
  ###
  unresolvedCount: 0
  
  ###
  @property [boolean] 
  ###
  isBrandNew: 0
  
  
  # settings
  
  ###
  @property [boolean] 
  ###
  fetchAutomatically: true
  

  # associations
  
  ###
  @property [Array<Agent>] 
  ###
  agents: null
  
  ###
  @property [Array<Product>] 
  ###
  products: null
  
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
  
  
  # billing
  
  ###
  @property [CreditCard] 
  ###
  creditCard: null
  
  ###
  @property [String] 
  ###
  billingEmail: null
  
  ###
  @property [float] 
  ###
  billingRate: -1

  ###
  @property [float]
  ###
  nextBillAmountBeforeDiscounts: 0.0

  ###
  @property [float]
  ###
  nextBillAmountAfterDiscounts: 0.0
  
  ###
  @property [boolean] 
  ###
  isFreeTrialEligible: false
  
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
  @param title [String] The title of the company.
  @param creator [Agent] The creator of the company. You can leave blank and it will make the current agent the creator.
  ###    
  @companyWithTitle: (title, creator) ->
    Firehose.Object._objectOfClassWithID Firehose.Company,
      title:    title
      _creator: creator || Firehose.Agent.loggedInAgent
  
  
  ###
  Create a company object when all you have is an id. You can then fetch articles or fetch the companies properties if you're authenticated as an agent of the company.
  @param id [number] The id of the company.
  @param token [number] The company token.
  @param creator [Agent] The agent that is the creator of this company. (This is mostly used internally).
  @return [Company] Returns a company object. If a company object with this id already exists in the cache, it will be returned.
  ###    
  @companyWithID: (id, token, creator) ->
    Firehose.Object._objectOfClassWithID Firehose.Company,
      id:       id
      token:    token
      _creator: creator
      
    
  ###
  Fetch a companies properties based on its `id`.
  @return [jqXHR Promise] Promise
  ###
  fetch: (options = {}) ->
    if @id?
      request = 
        route: "companies/#{@id}"
    else
      throw "You can't call 'fetch' on a company unless 'id' is set."
      
    Firehose.client.get( this, request ).done (data) =>
      this._populateWithJSON data
 
 
  ###
  Persists any changes you've made to the company to the server. Properties that can be updated: `title`, `fetch_automatically`
  @return [jqXHR Promise] Promise
  ###
  save: ->
    if @id?
      params = 
        route: "companies/#{@id}"
        body:  this._toJSON()
      Firehose.client.put( this, params )
    else
      params = 
        route: "agents/#{@_creator.id}/companies"
        body:  this._toJSON()
      Firehose.client.post( this, params ).done (data) =>
        this._populateWithJSON data
    
    
  ###
  Force a company to fetch it's accounts right now. (otherwise it's about every 10 minutes if `fetch_automatically` is true)
  @return [jqXHR Promise] Promise
  ###
  forceChannelsFetch: ->
    params = 
      route: "companies/#{@id}/force_channels_fetch"
    Firehose.client.put( this, params )
    
    
  ###
  Destroy a company. This will destroy all data associated with the company, including customers, interactions, notes, etc. It is asynchronous, so it will
  not be deleted immediately but in the background over the course of possibly an hour.
  @return [jqXHR Promise] Promise
  ###
  destroy: ->
    params = 
      route: "companies/#{@id}"
    Firehose.client.delete( this, params ).done =>
      Firehose.Agent.loggedInAgent.companies.dropObject this
    
  ###
  The customers of a company, filtered by a criteria.
  @param criteria [Object] A hash of criteria by which customers should be searched. 
  @option criteria [String] filter "everything" or "unresolved"
  @option criteria [String] channel A comma seperated list of channels to fetch (e.g. "twitter,email"). Omit to include all channels.
  @option criteria [String] sort "newest_first" or "oldest_first"
  @option criteria [String] search_text Any text that will be searched for an a customers name, email/twitter/facebook accunt name, and interaction body.
  @option criteria [String] preFetch Any one channel. If included, the server will synchronously fetch the channel specified. (e.g. "twitter")
  @return [RemoteArray<Customer>] The customer that matched the criteria.
  ###  
  customersWithCriteria: (criteria) ->
    criteria ?= {}
    params =
      filter:       if criteria.everything? and criteria.everything then "everything" else "unresolved"
      channel:      criteria.channels.join(",") if criteria.channels?
      sort:         if criteria.sort? then criteria.sort else "newest_first"
      search_text:  encodeURIComponent( criteria.searchString ) if criteria.searchString
    @_customers = new Firehose.RemoteArray "companies/#{@id}/customers", params, (json) =>
      Firehose.Customer.customerWithID( json.id, this )
    if params.sort == 'newest_first'
      @_customers.sortOn "newestInteractionReceivedAt", "desc"
    else
      @_customers.sortOn "newestInteractionReceivedAt", "asc"
    @_customers.onceParams = { pre_fetch: criteria.preFetch } if criteria.preFetch?
    @_customers
      
      
  ###
  The notifications of a company.
  @return [RemoteArray<TwitterAccount>] the Twitter accounts
  ###
  notifications: ->
    unless @_notifications?
      this._setIfNotNull "_notifications", new Firehose.RemoteArray "companies/#{@id}/notifications", null, (json) =>
        Firehose.Notification._notificationWithID( json.id, this )
      @_notifications.sortOn "title"
    @_notifications
    
    
  ###
  The Twitter accounts of a company
  @return [RemoteArray<TwitterAccount>] the Twitter accounts
  ###
  twitterAccounts: ->
    unless @_twitterAccounts?
      this._setIfNotNull "_twitterAccounts", new Firehose.RemoteArray "companies/#{@id}/twitter_accounts", null, (json) =>
        Firehose.TwitterAccount._twitterAccountWithID( json.id, this )
      @_twitterAccounts.sortOn "screenName"
    @_twitterAccounts
    
  
  ### 
  The Facebook accounts of a company.
  @return [RemoteArray<facebookAccount>] The found articles.
  ###
  facebookAccounts: ->
    unless @_facebookAccounts?
      this._setIfNotNull "_facebookAccounts", new Firehose.RemoteArray "companies/#{@id}/facebook_accounts", null, (json) =>
        Firehose.FacebookAccount._facebookAccountWithID( json.id, this )
      @_facebookAccounts.sortOn "name"
    @_facebookAccounts
    
    
  ### 
  The email accounts of a company.
  @return [RemoteArray<EmailAccount>] The found articles.
  ###
  emailAccounts: ->
    unless @_emailAccounts?
      this._setIfNotNull "_emailAccounts", new Firehose.RemoteArray "companies/#{@id}/email_accounts", null, (json) =>
        Firehose.EmailAccount._emailAccountWithID( json.id, this )
      @_emailAccounts.sortOn "username"
    @_emailAccounts
    
  
  ###
  Associates an agent with a company.
  @param agent [Agent] The agent to add.
  @return [jqXHR Promise] Promise
  ### 
  addAgent: (agent) ->
    params = 
      route: "companies/#{@id}/agents/#{agent.id}"
    Firehose.client.put( this, params ).done =>
      @agents.insertObject agent
    
  
  ###
  Removes an agent's association with a company.
  @param agent [Agent] The agent to remove.
  @return [jqXHR Promise] Promise
  ### 
  removeAgent: (agent) ->
    params = 
      route: "companies/#{@id}/agents/#{agent.id}"
    Firehose.client.delete( this, params ).done =>
      @agents.dropObject agent
    
    
  ###
  Fetches the billing info for the company from the billing server.
  This will populate `discounts` with a list of discount objects each having the follower properties:
    name: [String] The name of the discount.
    applyType: [String] either "percentage" or "fixed amount"
    amount: [number] The percentage or fixed amount to discount from the total price.
    expirationDate: [Date] When the discount expires and should not longer be applied to the monthly billing.
    @return [jqXHR Promise] Promise
  ###
  fetchBillingInfo: ->
    fetchBlock = =>
      Firehose.client.billingAccessToken = @token 
      params = 
        server: "billing"
        route: "entities/#{@id}"
      Firehose.client.get( this, params ).done (json) =>
        if json.credit_card?
          this._setIfNotNull "creditCard", Firehose.CreditCard.creditCardWithID( json.credit_card.id, this )
          @creditCard._populateWithJSON json.credit_card
        
        this._setIfNotNull "billingEmail",                  json.email || Firehose.Agent.loggedInAgent.email
        this._setIfNotNull "billingRate",                   (json.rate / 100.0).toFixed(2)
        this._setIfNotNull "nextBillAmountBeforeDiscounts", (@billingRate * @agents.length).toFixed(2)
        this._setIfNotNull "isFreeTrialEligible",           json.is_free_trial_eligible
        this._setIfNotNull "trialExpirationDate",           @_date( json.free_trial_expiration_date ) || new Date(+new Date + 12096e5) # 14 days away
        this._setIfNotNull "nextBillingDate",               if json.next_bill_date then @_date( json.next_bill_date )
        this._setIfNotNull "isGracePeriodOver",             json.grace_period_over
        this._setIfNotNull "daysLeftInGracePeriod",         json.days_left_in_grace_period
        this._setIfNotNull "isCurrent",                     json.current
        this._setIfNotNull "hasSuccessfulBilling",          json.has_successful_billing
        
        
        totalDiscount = 0.0
        discountAmt = 0.0
        discountAmtStr = ""

        @discounts = []
        for discount in json.discount_list
          if discount.apply_type is "fixed amount"
            discountAmt = (discount.amount / 100.0).toFixed(2)
            discountAmtStr = "$" + discountAmt
            totalDiscount = Number(totalDiscount) + Number(discountAmt)
          else
            discountAmt = discount.amount
            discountAmtStr = discountAmt + "%"
            totalDiscount = Number(totalDiscount) + Number(@nextBillAmountBeforeDiscounts * (discountAmt / 100))

          @discounts.push
            name:           discount.name
            applyType:      discount.apply_type
            amount:         discountAmt
            amountStr:      discountAmtStr
            expirationDate: if discount.expiration_date then @_date( discount.expiration_date )

        @nextBillAmountAfterDiscounts = (if (Number(totalDiscount) > Number(@nextBillAmountBeforeDiscounts)) then 0 else @nextBillAmountBeforeDiscounts - totalDiscount).toFixed(2)

    if @token
      fetchBlock()
    else
      this.fetch().then ->
        fetchBlock()
        
  ###
  If the company is still in trial and has 3 days left in its trial, the trial can be extended by the length of the original trial period.
  @return [jqXHR Promise] Promise
  ### 
  extendTrial: ->
    requestBlock = =>
      Firehose.client.billingAccessToken = @token 
      params = 
        server: "billing"
        route: "entities/#{@id}/renew_trial"
      Firehose.client.put( this, params ).done (json) =>
        this._setIfNotNull "trialExpirationDate", @_date( json.free_trial_expiration_date ) 
    if @token
      requestBlock()
    else
      this.fetch().then ->
        requestBlock()
      
    
  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "title",                         json.title
    this._setIfNotNull "token",                         json.token                  unless @token?
    this._setIfNotNull "lastFetchAt",                   @_date(json.last_fetch_at)  if json.last_fetch_at?
    this._setIfNotNull "forwardingEmailAddress",        json.forwarding_email       unless @forwardingEmailAddress?
    this._setIfNotNull "unresolvedCount",               json.unresolved_count
    this._setIfNotNull "isBrandNew",                    json.is_brand_new
        
    # settings    
    this._setIfNotNull "fetchAutomatically",            json.company_settings?.fetch_automatically
    
    this._populateAssociatedObjects this, "agents", json.agents, (json) =>
      agent = Firehose.Agent.agentWithID( json.id )
      agent.companies.insertObject this
      agent
      
    this._populateAssociatedObjects this, "products", json.products, (json) =>
      Firehose.Product.productWithID( json.id, this )
      
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
      title : @title
      company_settings_attributes:
        fetch_automatically            : @fetchAutomatically


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
      is_brand_new:         @isBrandNew
      # agents:               @agents._toArchivableJSON()   # gotta figure out how to imp this so it doesn't recurse infinitely
      agent_invites:        @agentInvites._toArchivableJSON()
      tags:                 @tags._toArchivableJSON()
      canned_responses:     @cannedResponses._toArchivableJSON()
