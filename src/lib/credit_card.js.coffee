class Firehose.CreditCard extends Firehose.Object


  # @nodoc
  @_firehoseType: "CreditCard"

  ###
  @property [Company]
  ###
  company: null

  ###
  @property [string] Only ever populated when set locally in preparation for submitting to Stripe.
  ###
  number: null

  ###
  @property [string] Only ever populated when set locally in preparation for submitting to Stripe.
  ###
  cvc: null

  ###
  @property [string]
  ###
  expirationMonth: null

  ###
  @property [string]
  ###
  expirationYear: null

  ###
  @property [string]
  ###
  lastFour: null

  ###
  @property [string]
  ###
  stripeToken: null

  ###
  @property [string] The e-mail receipts will be sent to.
  ###
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


  submitToStripe: (callback, ccEmail) ->
    @clearErrors()

    stripeErrorCodes:
      invalidNumber:      "invalid_number"
      invalidCVC:         "invalid_cvc"
      invalidExpiryMonth: "invalid_expiry_month"
      invalidExpiryYear:  "invalid_expiry_year"

    errorsFound = []

    if !@number?.trim() || number.length < 14
      errorsFound.push stripeErrorCodes.invalidNumber
    if !@cvc?trim()
      errorsFound.push stripeErrorCodes.invalidCVC
    if !@expirationMonth?.trim()
      errorsFound.push stripeErrorCodes.invalidExpiryMonth
    if !@expirationYear?.trim()
      errorsFound.push stripeErrorCodes.invalidExpiryYear

    Stripe.card.createToken
      number:     @number
      cvc:        @cvc
      exp_month:  @expirationMonth
      exp_year:   @expirationYear
    , (status, response) =>
      hasErrors = false
      if not response.error
        this._setIfNotNull "expirationMonth", response.card.exp_month
        this._setIfNotNull "expirationYear",  response.card.exp_year
        this._setIfNotNull "lastFour",        response.card.last4
        this._setIfNotNull "stripeToken",     response.id
        this._setIfNotNull "email",           if ccEmail? then ccEmail else Firehose.Agent.loggedInAgent.email
        hasErrors = errorsFound.length > 0
      else
        errorsFound.push response.error.code
        hasErrors = true

      if hasErrors
        @errors.push "Invalid credit card number" if $.inArray(_stripeErrorCodes.invalidNumber, errorsFound) > -1
        @errors.push "Invalid CVV"                if $.inArray(_stripeErrorCodes.invalidCVC, errorsFound) > -1
        @errors.push "Invalid Expiration Month"   if $.inArray(_stripeErrorCodes.invalidExpiryMonth, errorsFound) > -1
        @errors.push "Invalid Expiration Year"    if $.inArray(_stripeErrorCodes.invalidExpiryYear, errorsFound) > -1

      callback(hasErrors)


  save: ->
    Firehose.client.billingAccessToken = @company.token
    params =
      server: "billing"
      route:  "entities/#{@company.id}/credit_card"
      body:   this._toJSON()
    Firehose.client.put( this, params ).done =>
      @company.set 'creditCard', this


  fetch: ->
    Firehose.client.billingAccessToken = @company.token
    params =
      server: "billing"
      route: "entities/#{@company.id}/credit_card"
    Firehose.client.get( this, params ).done (data) =>
      this._populateWithJSON data


  destroy: ->
    Firehose.client.billingAccessToken = @company.token
    params =
      server: "billing"
      route: "entities/#{@company.id}/credit_card"
    Firehose.client.delete( this, params ).done =>
      @company.set 'creditCard', null


  # @nodoc
  _populateWithJSON: (json) ->
    this._setIfNotNull "expirationMonth", json.expiration_month
    this._setIfNotNull "expirationYear",  json.expiration_year
    this._setIfNotNull "lastFour",        json.last_four
    this._setIfNotNull "email",           json.email
    super json


  # @nodoc
  _toJSON: ->
    credit_card:
      expiration_month: @expirationMonth
      expiration_year:  @expirationYear
      last_four:        @lastFour
      stripe_token:     @stripeToken
      email:            @email