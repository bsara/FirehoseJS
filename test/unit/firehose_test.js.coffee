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

module "FirehoseJS"

test 'env', ->
  ok FirehoseJS.env() == 'test'
  ok FirehoseJS.env() != 'development'
  ok FirehoseJS.env() != 'production'
  
test 'rootFor', ->
  ok FirehoseJS.rootFor('API') == 'http://localhost:3010'
  ok FirehoseJS.rootFor('browser') == 'http://localhost:3011'

test 'tokenFor', ->
  ok FirehoseJS.tokenFor('pusher') == '2f64ac0434cc8a94526e'
  ok FirehoseJS.tokenFor('stripe') == 'pk_test_oIyMNHil987ug1v8owRhuJwr'
