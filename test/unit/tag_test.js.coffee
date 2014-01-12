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

module "Tag"

firehoseTest 'Create', 4, (agent) ->
  company = agent.companies[0]
  tag = FirehoseJS.Tag.tagWithLabel( Faker.Lorem.words(1).join(" "), company)
  tag.save()
  .done (data, textStatus) ->
    equal textStatus, "success"
    ok tag.id?
    ok tag.label?
    ok tag.createdAt?
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Update', 1, (agent) ->
  company = agent.companies[0]
  tag = FirehoseJS.Tag.tagWithLabel( Faker.Lorem.words(1).join(" "), company)
  tag.save()
  .done (data, textStatus) ->
    tag.label = Faker.Lorem.words(1).join(" ")
    tag.save()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  tag = FirehoseJS.Tag.tagWithLabel( Faker.Lorem.words(1).join(" "), company)
  tag.save()
  .done (data, textStatus) ->
    tag.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()