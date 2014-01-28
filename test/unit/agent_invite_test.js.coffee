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

module "Agent Invite"

firehoseTest 'Create', 1, (agent) ->
  company = agent.companies[0]
  agentInvite = FirehoseJS.AgentInvite.agentInviteWithEmail( Faker.Lorem.words(1).join(" "), company)
  agentInvite.save()
  .done (data, textStatus) ->
    equal textStatus, "success"
    start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Resend', 1, (agent) ->
  company = agent.companies[0]
  agentInvite = FirehoseJS.AgentInvite.agentInviteWithEmail( Faker.Lorem.words(1).join(" "), company)
  agentInvite.save()
  .done (data, textStatus) ->
    agentInvite.resend()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()

firehoseTest 'Destroy', 1, (agent) ->
  company = agent.companies[0]
  agentInvite = FirehoseJS.AgentInvite.agentInviteWithEmail( Faker.Lorem.words(1).join(" "), company)
  agentInvite.save()
  .done (data, textStatus) ->
    agentInvite.destroy()
    .done (data, textStatus) ->
      equal textStatus, "nocontent"
      start()
    .fail (jqXHR, textStatus, errorThrown) ->
      start()
  .fail (jqXHR, textStatus, errorThrown) ->
    start()
    
