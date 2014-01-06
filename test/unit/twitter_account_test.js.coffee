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

module "Twitter Account"

firehoseTest 'OAuth URL', 1, (agent) ->
  company = agent.companies[0]
  url = FirehoseJS.TwitterAccount.OAuthURLForCompanyWithCallback( company, "test://" )
  ok url.length > 10
  start()

firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  twitterAccounts = company.twitterAccounts()
  twitterAccounts.next() 
  .done (data, textStatus) ->
    facebookAccount = twitterAccounts[0]
    facebookAccount.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
