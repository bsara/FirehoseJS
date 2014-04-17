class Firehose.CreditCard extends Firehose.Object


  # @nodoc
  @_firehoseType: "CreditCard"

  ###
  @property [Company]
  ###
  company: null

  ###
  @property [String] Only ever populated when set locally in preparation for submitting to Stripe.
  ###
  number: null

  ###
  @property [String] Only ever populated when set locally in preparation for submitting to Stripe.
  ###
  cvc: null

  ###
  @property [String]
  ###
  expirationMonth: null

  ###
  @property [String]
  ###
  expirationYear: null

  ###
  @property [String]
  ###
  lastFour: null

  ###
  @property [String]
  ###
  stripeToken: null

  ###
  @property [String] The e-mail receipts will be sent to.
  ###
  email: null


  ###
  Create a credit card for submitting to Stripe.
  @param number [String] The credit card number.
  @param cvc [number] The cvc
  @param expMonth [number] String of a number between "01" and "12" representing the expiration month.
  @param expYear [number] String of the expiration year (e.g. "2014")
  @param email [String] The email that receipts should be sent to.
  @param company [Company] The company this card will be added to
  @return [CreditCard] Returns a credit card that can then be sumitted to Stripe for a token and saved to Firehose.
  ###
  @creditCardWithNumber: (number, cvc, expMonth, expYear, email, company) ->
    Firehose.Object._objectOfClassWithID Firehose.CreditCard,
    number:          number
    cvc:             cvc
    expirationMonth: expMonth
    expirationYear:  expYear
    email:           email
    company:         company


  ###
  Create a credit card for submitting to Stripe.
  @param id [number] The id of the credit card object from the api.
  @param company [Company] The company this card will be added to
  @return [CreditCard] Returns a credit card that can then be fetched.
  ###
  @creditCardWithID: (id, company) ->
    Firehose.Object._objectOfClassWithID Firehose.CreditCard,
      id:      id
      company: company


  submitToStripe: (callback, ccEmail) ->
    @clearErrors()

    stripeErrorCodes =
      invalidNumber:      "invalid_number"
      invalidCVC:         "invalid_cvc"
      invalidExpiryMonth: "invalid_expiry_month"
      invalidExpiryYear:  "invalid_expiry_year"

    errorsFound = []

    if !@number?.trim()
      errorsFound.push stripeErrorCodes.invalidNumber
    if !@cvc? || !String(@cvc).trim() || typeof @cvc != "number"
      errorsFound.push stripeErrorCodes.invalidCVC
    if !@expirationMonth? || !String(@expirationMonth).trim() || typeof @expirationMonth != "number"
      errorsFound.push stripeErrorCodes.invalidExpiryMonth
    if !@expirationYear? || !String(@expirationYear).trim() || typeof @expirationYear != "number"
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
        this._setIfNotNull "email",           if ccEmail?.trim() then ccEmail.trim() else Firehose.Agent.loggedInAgent.email
        hasErrors = errorsFound.length > 0
      else
        errorsFound.push response.error.code
        hasErrors = true

      if hasErrors
        @errors.push "Credit card number is invalid" if $.inArray(stripeErrorCodes.invalidNumber, errorsFound) > -1
        @errors.push "CVV is invalid"                if $.inArray(stripeErrorCodes.invalidCVC, errorsFound) > -1
        @errors.push "Expiration month is invalid"   if $.inArray(stripeErrorCodes.invalidExpiryMonth, errorsFound) > -1
        @errors.push "Expiration year is invalid"    if $.inArray(stripeErrorCodes.invalidExpiryYear, errorsFound) > -1

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