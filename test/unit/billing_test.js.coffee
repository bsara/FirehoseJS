module "Billing"


###
I honestly can't remember why all these tests need to use agent1, but when I tried to just use the passed in agent, they all failed with this error:
Called start() while already started (QUnit.config.semaphore was 0 already)
and only 2 or so of the assertions would run. I remember there being a reason and this was my solution, but can't remember it now.
###

firehoseTest "Fetch Billing Info", 18, (agent) ->
  firstAgent = Firehose.Agent.agentWithEmailAndPassword( "agent1@example.com", "pw" )
  firstAgent.login()
  .done ->
    company = firstAgent.companies[0]
    company.token = "entity_token_#{company.id}"
    company.fetchBillingInfo()
    .done (data, textStatus) ->
      equal textStatus, "success"
      ok company.billingEmail?
      ok company.billingRate?
      ok company.daysLeftInGracePeriod?
      ok company.hasSuccessfulBilling?
      ok company.isCurrent?
      ok company.isGracePeriodOver?
      ok company.nextBillingDate?
      ok company.nextBillAmountBeforeDiscounts?
      ok company.nextBillAmountAfterDiscounts?
      ok company.isFreeTrialEligible?
      ok company.trialExpirationDate?
      ok company.discounts.length == 1
      ok company.discounts[0].amount?
      ok company.discounts[0].amountStr?
      ok company.discounts[0].applyType?
      ok company.discounts[0].expirationDate?
      ok company.discounts[0].name?
      start()
    .fail ->
      start()
  .fail ->
    start()


firehoseTest "Extend Trial", 4, (agent) ->
  firstAgent = Firehose.Agent.agentWithEmailAndPassword( "agent1@example.com", "pw" )
  firstAgent.login()
  .done ->
    company = firstAgent.companies[0]
    company.token = "entity_token_#{company.id}"
    company.fetchBillingInfo()
    .done (data, fetchBillingInfoTextStatus) ->
      equal fetchBillingInfoTextStatus, "success"
      equal company.isFreeTrialEligible, true

      trialExpDate = company.trialExpirationDate?

      company.extendTrial()
      .done (data, extendTrialTextStatus) ->
        equal extendTrialTextStatus, "success"

        shouldEnd = new Date
        shouldEnd.setDate( shouldEnd.getDate() + 14 )

        ok company.trialExpirationDate, shouldEnd
        start()
      .fail ->
        start()
    .fail ->
      start()
  .fail ->
    start()


firehoseTest "Add", 13, (agent) ->
  firstAgent = Firehose.Agent.agentWithEmailAndPassword( "agent1@example.com", "pw" )
  firstAgent.login()
  .done ->
    expectedCreditCardExpirationMonth = 4
    expectedCreditCardExpirationYear = 2020
    expectedCreditCardLastFour = "4242"
    expectedCreditCardEmail = firstAgent.email

    company = firstAgent.companies[0]
    creditCard = Firehose.CreditCard.creditCardWithNumber(
      "424242424242" + expectedCreditCardLastFour,
      888,
      expectedCreditCardExpirationMonth,
      expectedCreditCardExpirationYear,
      expectedCreditCardEmail,
      company
    )

    creditCard.submitToStripe(((hasErrors) ->
      equal hasErrors, false, "no errors should have been returned from stripe"
      equal creditCard.errors.length, 0, "errors array should be empty"

      company.token = "entity_token_#{company.id}"

      creditCard.save()
      .done (data, textStatus) ->
        equal textStatus, "nocontent"

        ok creditCard.expirationMonth?
        ok creditCard.expirationYear?
        ok creditCard.lastFour?
        ok creditCard.stripeToken?
        ok creditCard.email?

        equal creditCard.expirationMonth, expectedCreditCardExpirationMonth, "creditCard.expirationMonth"
        equal creditCard.expirationYear, expectedCreditCardExpirationYear, "creditCard.expirationYear"
        equal creditCard.lastFour, expectedCreditCardLastFour, "creditCard.lastFour"
        equal creditCard.email, expectedCreditCardEmail, "creditCard.email"
        equal creditCard.errors.length, 0, "errors array should be empty"

        start()
      .fail ->
        start()
    ), firstAgent.email)
  .fail ->
    start()


firehoseTest "Fetch", 14, (agent) ->
  firstAgent = Firehose.Agent.agentWithEmailAndPassword( "agent1@example.com", "pw" )
  firstAgent.login()
  .done ->
    expectedCreditCardExpirationMonth = 4
    expectedCreditCardExpirationYear = 2020
    expectedCreditCardLastFour = "4242"
    expectedCreditCardEmail = firstAgent.email

    company = firstAgent.companies[0]
    creditCard = Firehose.CreditCard.creditCardWithNumber(
      "424242424242" + expectedCreditCardLastFour,
      888,
      expectedCreditCardExpirationMonth,
      expectedCreditCardExpirationYear,
      expectedCreditCardEmail,
      company
    )

    creditCard.submitToStripe(((hasErrors) ->
      equal hasErrors, false, "no errors should have been returned from stripe"
      equal creditCard.errors.length, 0, "errors array should be empty"

      company.token = "entity_token_#{company.id}"

      creditCard.save()
      .done ->
        equal creditCard.errors.length, 0, "errors array should be empty"

        creditCard.fetch()
        .done (data, textStatus) ->
          equal textStatus, "success"

          ok creditCard.expirationMonth?
          ok creditCard.expirationYear?
          ok creditCard.lastFour?
          ok creditCard.stripeToken?
          ok creditCard.email?

          equal creditCard.expirationMonth, expectedCreditCardExpirationMonth, "creditCard.expirationMonth"
          equal creditCard.expirationYear, expectedCreditCardExpirationYear, "creditCard.expirationYear"
          equal creditCard.lastFour, expectedCreditCardLastFour, "creditCard.lastFour"
          equal creditCard.email, expectedCreditCardEmail, "creditCard.email"
          equal creditCard.errors.length, 0, "errors array should be empty"

          start()
        .fail ->
          start()
      .fail ->
        start()
    ), firstAgent.email)
  .fail ->
    start()


firehoseTest "Remove", 4, (agent) ->
  firstAgent = Firehose.Agent.agentWithEmailAndPassword( "agent1@example.com", "pw" )
  firstAgent.login()
  .done ->
    company = firstAgent.companies[0]
    creditCard = Firehose.CreditCard.creditCardWithNumber( "4242424242424242", 888, 4, 2014, firstAgent.email, company )
    creditCard.submitToStripe(((hasErrors) ->
      equal hasErrors, false, "no errors should have been returned from stripe"
      equal creditCard.errors.length, 0, "errors array should be empty"

      company.token = "entity_token_#{company.id}"

      creditCard.save()
      .done ->
        creditCard.destroy()
        .done (data, textStatus) ->
          equal textStatus, "nocontent"
          equal company.creditCard, null, "company.creditCard"
          # TODO: add a creditCard.fetch and associated assertions here to ensure that full removal occurred
          start()
        .fail ->
          start()
      .fail ->
        start()
    ), firstAgent.email)
  .fail ->
    start()