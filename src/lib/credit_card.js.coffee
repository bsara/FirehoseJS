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
    creditCard = FirehoseJS.Object._objectOfClassWithID( FirehoseJS.CreditCard, null )
    creditCard.number           = number
    creditCard.cvc              = cvc
    creditCard.expirationMonth  = expMonth
    creditCard.expirationYear   = expYear
    creditCard.company          = company
    creditCard 
  
    
  @creditCardWithID: (id, company) ->
    creditCard = FirehoseJS.Object._objectOfClassWithID( FirehoseJS.CreditCard, id )
    creditCard.company = company
    creditCard 
    
  
  submitToStripe: (callback) ->
    Stripe.card.createToken
      number:     @number
      cvc:        @cvc
      exp_month:  @expirationMonth
      exp_year:   @expirationYear
    , (status, response) =>
      if not response.error
        @expirationMonth  = response.card.exp_month
        @expirationYear   = response.card.exp_year
        @lastFour         = response.card.last4
        @stripeToken      = response.id
        @email            = FirehoseJS.Agent.loggedInAgent.email
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
    @expirationMonth  = json.expiration_month
    @expirationYear   = json.expiration_year
    @lastFour         = json.last_four
    super json


  _toJSON: ->
    credit_card:
      expiration_month: @expirationMonth
      expiration_year:  @expirationYear
      last_four:        @lastFour
      stripe_token:     @stripeToken
      email:            @email
    