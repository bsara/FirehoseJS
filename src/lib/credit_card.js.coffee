class FirehoseJS.CreditCard extends FirehoseJS.Object
  
  
  company: null
  
  expirationMonth: null
  
  expirationYear: null
  
  lastFour: null
  
  stripeToken: null
  
  email: null
  
  
  constructor: (company) ->
    @company = company
    
  
  submitToStripe: (number, cvc, expMonth, expYear, callback) ->
    Stripe.card.createToken
      number: number
      cvc: cvc
      exp_month: expMonth
      exp_year: expYear
    , (status, response) =>
      if not response.error
        @expirationMonth  =  response.card.exp_month
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
    