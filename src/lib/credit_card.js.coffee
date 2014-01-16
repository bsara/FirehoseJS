class FirehoseJS.CreditCard extends FirehoseJS.Object
  
  
  company: null
  
  number: null 
  
  cvc: null
  
  expirationMonth: null
  
  expirationYear: null
  
  lastFour: null
  
  stripeToken: null
  
  email: null
    
    
  @creditCardWithNumber: (number, cvc, expMonth, expYear, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.CreditCard, 
    number:          number
    cvc:             cvc
    expirationMonth: expMonth
    expirationYear:  expYear
    company:         company
     
  
    
  @creditCardWithID: (id, company) ->
    FirehoseJS.Object._objectOfClassWithID FirehoseJS.CreditCard,
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
        this.setIfNotNull "expirationMonth", response.card.exp_month
        this.setIfNotNull "expirationYear",  response.card.exp_year
        this.setIfNotNull "lastFour",        response.card.last4
        this.setIfNotNull "stripeToken",     response.id
        this.setIfNotNull "email",           FirehoseJS.Agent.loggedInAgent.email
        callback()
      
    
  save: ->
    FirehoseJS.client.billingAccessToken = @company.token 
    params = 
      server: "billing"
      route:  "entities/#{@company.id}/credit_card"
      body:   this._toJSON()
    FirehoseJS.client.put( params )
    
    
  fetch: ->
    FirehoseJS.client.billingAccessToken = @company.token 
    params = 
      server: "billing"
      route: "entities/#{@company.id}/credit_card"
    FirehoseJS.client.get( params ).done (data) =>
      this._populateWithJSON data
    
    
  destroy: ->
    FirehoseJS.client.billingAccessToken = @company.token 
    params = 
      server: "billing"
      route: "entities/#{@company.id}/credit_card"
    FirehoseJS.client.delete( params )
    
    
  _populateWithJSON: (json) ->
    this.setIfNotNull "expirationMonth", json.expiration_month
    this.setIfNotNull "expirationYear",  json.expiration_year
    this.setIfNotNull "lastFour",        json.last_four
    super json


  _toJSON: ->
    credit_card:
      expiration_month: @expirationMonth
      expiration_year:  @expirationYear
      last_four:        @lastFour
      stripe_token:     @stripeToken
      email:            @email
    