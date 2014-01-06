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

module "Canned Response"

firehoseTest 'Create', 1, (agent) ->
  company = agent.companies[0]
  cannedResponse = new FirehoseJS.CannedResponse( Faker.Lorem.words(1).join(" "), Faker.Lorem.words(10).join(" "), company)
  cannedResponse.save()
  .done (data, textStatus) ->
    equal textStatus, "success"
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Update', 1, (agent) ->
  company = agent.companies[0]
  cannedResponse = new FirehoseJS.CannedResponse( Faker.Lorem.words(1).join(" "), Faker.Lorem.words(10).join(" "), company)
  cannedResponse.save()
  .done (data, textStatus) ->
    cannedResponse.text = Faker.Lorem.words(50).join(" ")
    cannedResponse.save()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  cannedResponse = new FirehoseJS.CannedResponse( Faker.Lorem.words(1).join(" "), Faker.Lorem.words(10).join(" "), company)
  cannedResponse.save()
  .done (data, textStatus) ->
    cannedResponse.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()