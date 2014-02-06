module "Firehose"
  
test 'baseURLFor', ->
  ok Firehose.baseURLFor('API') == 'http://localhost:3010'
  ok Firehose.baseURLFor('browser') == 'http://localhost:4011'

test 'tokenFor', ->
  ok Firehose.tokenFor('pusher') == '2f64ac0434cc8a94526e'
  ok Firehose.tokenFor('stripe') == 'pk_test_oIyMNHil987ug1v8owRhuJwr'
