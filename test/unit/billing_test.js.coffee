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

firehoseTest 'Fetch Billing Info', 2, (agent) ->
  firstAgent = new FirehoseJS.Agent( "agent1@example.com", "pw" )
  firstAgent.login()
  .done (data, textStatus) ->
    company = firstAgent.companies[0]
    company.token = "entity_token_#{company.id}"
    company.fetchBillingInfo()
    .done (data, textStatus) ->
      equal textStatus, "success"
      ok company.billingEmail?
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Add', 6, (agent) ->
  firstAgent = new FirehoseJS.Agent( "agent1@example.com", "pw" )
  firstAgent.login()
  .done (data, textStatus) ->
    company = firstAgent.companies[0]
    creditCard = new FirehoseJS.CreditCard( company )
    creditCard.submitToStripe "4242424242424242", 888, 4, 2014, ->
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
    
firehoseTest 'Add', 6, (agent) ->
  firstAgent = new FirehoseJS.Agent( "agent1@example.com", "pw" )
  firstAgent.login()
  .done (data, textStatus) ->
    company = firstAgent.companies[0]
    creditCard = new FirehoseJS.CreditCard( company )
    creditCard.submitToStripe "4242424242424242", 888, 4, 2014, ->
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
  firstAgent = new FirehoseJS.Agent( "agent1@example.com", "pw" )
  firstAgent.login()
  .done (data, textStatus) ->
    company = firstAgent.companies[0]
    creditCard = new FirehoseJS.CreditCard( company )
    creditCard.submitToStripe "4242424242424242", 888, 4, 2014, ->
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

