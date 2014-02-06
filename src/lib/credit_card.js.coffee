class Firehose.CreditCard extends Firehose.Object
  
  
  # @nodoc
  @_firehoseType: "CreditCard"
  
  company: null
  
  number: null 
  
  cvc: null
  
  expirationMonth: null
  
  expirationYear: null
  
  lastFour: null
  
  stripeToken: null
  
  email: null
    
    
  @creditCardWithNumber: (number, cvc, expMonth, expYear, email, company) ->
    Firehose.Object._objectOfClassWithID Firehose.CreditCard, 
    number:          number
    cvc:             cvc
    expirationMonth: expMonth
    expirationYear:  expYear
    email:           email
    company:         company
     
  
    
  @creditCardWithID: (id, company) ->
    Firehose.Object._objectOfClassWithID Firehose.CreditCard,
      id:      id
      company: company
    
  
  submitToStripe: (callback) ->
    Stripe.card.createToken
      number:     @number
      cvc:        @cvc
      exp_month:  @expirationMonth
      exp_year:   @expirationYear
    , (status, response) =>
      if not response.error
        this._setIfNotNull "expirationMonth", response.card.exp_month
        this._setIfNotNull "expirationYear",  response.card.exp_year
        this._setIfNotNull "lastFour",        response.card.last4
        this._setIfNotNull "stripeToken",     response.id
        this._setIfNotNull "email",           Firehose.Agent.loggedInAgent.email
        callback()
      else
        callback response.error
      
    
  save: ->
    Firehose.client.billingAccessToken = @company.token 
    params = 
      server: "billing"
      route:  "entities/#{@company.id}/credit_card"
      body:   this._toJSON()
    Firehose.client.put( params ).done =>
      @company.set 'creditCard', this
    
    
  fetch: ->
    Firehose.client.billingAccessToken = @company.token 
    params = 
      server: "billing"
      route: "entities/#{@company.id}/credit_card"
    Firehose.client.get( params ).done (data) =>
      this._populateWithJSON data
    
    
  destroy: ->
    Firehose.client.billingAccessToken = @company.token 
    params = 
      server: "billing"
      route: "entities/#{@company.id}/credit_card"
    Firehose.client.delete( params ).done =>
      @company.set 'creditCard', null
    
    
  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "expirationMonth", json.expiration_month
    this._setIfNotNull "expirationYear",  json.expiration_year
    this._setIfNotNull "lastFour",        json.last_four
    super json


  # @nodoc
  _toJSON: ->
    credit_card:
      expiration_month: @expirationMonth
      expiration_year:  @expirationYear
      last_four:        @lastFour
      stripe_token:     @stripeToken
      email:            @email
    