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

module "Note"

firehoseTest 'Create', 1, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria( channels: ["twitter"] )
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]
    interactions = customer.interactions()
    interactions.next()
    .done (data, textStatus) ->
      interaction = interactions[0]
      note = new FirehoseJS.Note( Faker.Lorem.words(5).join(" "), interaction )
      note.save()
      .done (data, textStatus) ->
        ok textStatus == "success"
        start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Update', 1, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria( channels: ["twitter"] )
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]
    interactions = customer.interactions()
    interactions.next()
    .done (data, textStatus) ->
      interaction = interactions[0]
      note = new FirehoseJS.Note( Faker.Lorem.words(5).join(" "), interaction )
      note.save()
      .done (data, textStatus) ->
        note.body = Faker.Lorem.words(50).join(" ")
        note.save()
        .done (data, textStatus) ->
          ok textStatus == "nocontent"
          start()
        .fail (jqXHR, textStatus, errorThrown) ->
          start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  customers = company.customersWithCriteria( channels: ["twitter"] )
  customers.next()
  .done (data, textStatus) ->
    customer = customers[0]
    interactions = customer.interactions()
    interactions.next()
    .done (data, textStatus) ->
      interaction = interactions[0]
      note = new FirehoseJS.Note( Faker.Lorem.words(5).join(" "), interaction )
      note.save()
      .done (data, textStatus) ->
        note.destroy()
        .done (data, textStatus) ->
          ok textStatus == "nocontent"
          start()
        .fail (jqXHR, textStatus, errorThrown) ->
          start()
      .fail (jqXHR, textStatus, errorThrown) ->
        start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()