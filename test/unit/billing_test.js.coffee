# ======== A Handy Little QUnit Reference ========
# http://api.qunitjs.com/

# Test methods:
#   module(name, {[setup][ ,teardown]})
#   test(name, callback)
#   expect(numberOfAssertions)
#   stop(increment)
#   start(decrement)
# Test assertions:
#   ok(value, [message])
#   equal(actual, expected, [message])
#   notEqual(actual, expected, [message])
#   deepEqual(actual, expected, [message])
#   notDeepEqual(actual, expected, [message])
#   strictEqual(actual, expected, [message])
#   notStrictEqual(actual, expected, [message])
#   throws(block, [expected], [message])

FirehoseJS.client.setEnvironment('test')

module "Billing"


###
I honestly can't remember why all these tests need to use agent1, but when I tried to just use the passed in agent, they all failed with this error:
Called start() while already started (QUnit.config.semaphore was 0 already)
and only 2 or so of the assertions would run. I remember there being a reason and this was my solution, but can't remember it now.
###

firehoseTest 'Fetch Billing Info', 14, (agent) ->
  firstAgent = FirehoseJS.Agent.agentWithEmailAndPassword( "agent1@example.com", "pw" )
  firstAgent.login()
  .done (data, textStatus) ->
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
      ok company.trialExpirationDate?
      ok company.discounts.length == 1
      ok company.discounts[0].amount?
      ok company.discounts[0].applyType?
      ok company.discounts[0].expirationDate?
      ok company.discounts[0].name?
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Add', 6, (agent) ->
  firstAgent = FirehoseJS.Agent.agentWithEmailAndPassword( "agent1@example.com", "pw" )
  firstAgent.login()
  .done (data, textStatus) ->
    company = firstAgent.companies[0]
    creditCard = FirehoseJS.CreditCard.creditCardWithNumber( "4242424242424242", 888, 4, 2014, firstAgent.email, company )
    creditCard.submitToStripe ->
      company.token = "entity_token_#{company.id}"
      creditCard.save()
      .done (data, textStatus) ->
        equal textStatus, "nocontent"
        ok creditCard.expirationMonth?
        ok creditCard.expirationYear?
        ok creditCard.lastFour?
        ok creditCard.stripeToken?
        ok creditCard.email?
        start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Fetch', 6, (agent) ->
  firstAgent = FirehoseJS.Agent.agentWithEmailAndPassword( "agent1@example.com", "pw" )
  firstAgent.login()
  .done (data, textStatus) ->
    company = firstAgent.companies[0]
    creditCard = FirehoseJS.CreditCard.creditCardWithNumber( "4242424242424242", 888, 4, 2014, firstAgent.email, company )
    creditCard.submitToStripe ->
      company.token = "entity_token_#{company.id}"
      creditCard.save()
      .done (data, textStatus) ->
        creditCard.fetch()
        .done (data, textStatus) ->
          equal textStatus, "success"
          ok creditCard.expirationMonth?
          ok creditCard.expirationYear?
          ok creditCard.lastFour?
          ok creditCard.stripeToken?
          ok creditCard.email?
          start()
        .fail (jqXHR, textStatus, errorThrown) ->
          start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Remove', 1, (agent) ->
  firstAgent = FirehoseJS.Agent.agentWithEmailAndPassword( "agent1@example.com", "pw" )
  firstAgent.login()
  .done (data, textStatus) ->
    company = firstAgent.companies[0]
    creditCard = FirehoseJS.CreditCard.creditCardWithNumber( "4242424242424242", 888, 4, 2014, firstAgent.email, company )
    creditCard.submitToStripe ->
      company.token = "entity_token_#{company.id}"
      creditCard.save()
      .done (data, textStatus) ->
        creditCard.destroy()
        .done (data, textStatus) ->
          equal textStatus, "nocontent"
          start()
        .fail (jqXHR, textStatus, errorThrown) ->
          start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

