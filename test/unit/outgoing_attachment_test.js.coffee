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

module "Outgoing Attachment"

# firehoseTest 'Dismiss', 1, (agent) ->
#   company = agent.companies[0]
#   notifications = company.notifications()
#   notifications.next()
#   .done (data, textStatus) ->
#     agent.dismissNotifications( notifications )
#     .done (data, textStatus) ->
#       ok textStatus == "nocontent"
#       start()
#     .fail (jqXHR, textStatus, errorThrown) ->
#       start()    
#   .fail (jqXHR, textStatus, errorThrown) ->
#     start()    
    
